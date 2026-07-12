# Fragment 翻译增强：完整工作汇报

> 本文面向两类读者：
> - **导师**：了解做了什么、为什么这么做、学术依据是什么
> - **同组同学**：拿着这一份文档就能快速接手本项目工作
>
> 配套文件：
> - `docs/related_work_code_translation.md` — 15 篇论文的详细摘要与相关度评级
> - `docs/fragment_translation_enhancements.md` — 实现细节、CLI 参数、消融测试使用说明
> - `docs/start.md` — 项目原有 pipeline 的完整搭建与运行步骤

---

## 1. 背景：x2cangjie 在做什么

x2cangjie 把 Java 库自动翻译成仓颉（Cangjie）语言。整体 pipeline 基于 TRAM 架构，但用 tree-sitter（而非 CodeQL）解析 Java AST。翻译流程是**增量**的：先生成带 `throw Exception('TODO')` 占位符的 .cj 骨架文件，再逐个 fragment 用 LLM 翻译填充，每填一个就跑 `cjpm build` 编译验证，失败则带编译错误反馈重试。

8 步 pipeline（每步对应一个 shell 脚本）：

```
preprocess → create_schema → get_dependencies → translate_types
→ create_skeleton → build_mock_corpus → translate_fragment → analyze_errors
```

其中 **第 7 步 `translate_fragment`** 是核心——LLM 在这里把每个 Java fragment 翻译成 Cangjie。我们观察到翻译结果有两类系统性错误：

| 错误类型 | 表现 | 根因 |
|---|---|---|
| **A: 错误继承 Java 源语法/API 模式** | LLM 照搬 Java 的实现方式（如 `for-each lambda`、`checked exception`、`stream API`），即使 Cangjie 不支持 | LLM 倾向于模仿源代码的结构，而非理解意图后用目标语言惯用法重写 |
| **B: 使用错误的 Cangjie 语法/API** | 泛型约束写错（用了 `extends` 而非 `where T <: Bound`）、`Any` 当 HashMap key（不满足 `Hashable`）、`boolean` 而非 `Bool` | Cangjie 是新语言，LLM 训练数据中几乎没有 Cangjie 代码 |

针对这两类错误，我们做了三件事（称 Part 1 / Part 2 / Part 3），三者互相独立、可单独或组合开关，默认全部关闭，向后完全兼容。

---

## 2. Part 1：伪代码中间层（解决错误 A）

### 2.1 参考论文

| 论文 | 出处 | 核心思想 |
|---|---|---|
| **A1: Can Emulating Semantic Translation Help LLMs with Code Translation? A Study Based on Pseudocode** | arXiv:2510.00920, 2025; 代码: github.com/imcsq/Pseudocode-based-Code-Translation | 模拟人类自然语言翻译中的"语义翻译"策略：源→目标语法差异大时，先理解源码意图用伪代码表达，再基于伪代码生成目标代码。两阶段 `Source → Pseudocode → Target` |
| A3: NL in the Middle | CASCON 2025 | 系统对比 NL summary vs AST 作为中间表示，发现 **自然语言中间表示效果最好**（CoT + NL summary 比零样本提升 13.8%） |
| A4: Unraveling the Potential of LLMs in Code Translation | arXiv:2410.09812 | 提出"风格转换"思路：先去掉源语言特有模式再翻译 |
| A6: Assessing Code Generation with Intermediate Languages | arXiv:2407.05411 | 重要警示：伪代码收益可能部分来自 CoT 多步推理效应，建议做 ablation 验证 |

**A1 是最直接的前身**——论文做的就是 `Source → Pseudocode → Target`，有完整 GitHub replication package，我们的 prompt 设计直接参考了它。

### 2.2 论文原理

A1 的核心发现用一个例子说明（取自论文 Figure 2）：

- **直接翻译** Python → Java 时，LLM 试图模仿 Python 的 `for-loop lambda` 实现，但 Java 不支持该模式，结果生成了结构相似但语义不一致的代码。
- **伪代码中间层**：LLM 先把 Python 程序抽象成伪代码（描述意图和逻辑），再从伪代码生成 Java，此时 LLM 用了 Java 的惯用方式（临时数组整体更新），得到正确结果。

论文测试了 5 种策略组合（仅伪代码、伪代码+源代码、伪代码+源代码+反馈等），发现 **"伪代码 + 源代码"组合** 效果最好——LLM 可以参照源代码解决伪代码中的歧义。

A3 进一步发现：自然语言中间表示 > AST 结构化中间表示。这意味着伪代码应该**偏自然语言**（带注释），而非偏代码结构。

### 2.3 项目中的实现

我们在 `translate_fragment` 的主翻译循环中插入了一个 Phase-1 LLM 调用：

```
原流程:  Java fragment → [prompt] → LLM → Cangjie
新流程:  Java fragment → LLM → 伪代码+注释  ← Phase-1 (新增)
                ↓
          伪代码 + Java源码 + 其他metadata → [prompt] → LLM → Cangjie  ← Phase-2 (原有，prompt 增加了伪代码块)
```

**Phase-1 prompt 规约**（定义在 `compositional_translation_validation.py` 的 `PSEUDOCODE_SYSTEM_PROMPT`）：

要求 LLM 输出的伪代码：
1. 仅一套三反引号包裹
2. 仅使用 `FOR / WHILE / IF / ELSE / RETURN / BREAK` 等通用关键字
3. 每个 Java API 调用改写为动词短语（`Collections.sort(xs)` → `sort xs in place`）
4. 每个逻辑块前用 `//` 注释说明意图
5. 不提及 Cangjie/Python 等任何目标语言
6. 保持原始控制流顺序与变量名

**关键设计决策**：

- **不丢弃 Java 源码**：Phase-2 的 prompt 同时包含 Java 源代码和伪代码（对应 A1 的 Strategy 4/5），伪代码居中解决歧义，源码作为 fallback。
- **失败退化为直接翻译**：Phase-1 LLM 调用失败（网络/空响应）时返回空串，Phase-2 在无伪代码的情况下继续，不影响主流程。
- **`_skip_prompt_build` 优化**：Phase-1 内部需要 Java 源码来生成伪代码，但不需要 RAG/KB/generics 等昂贵上下文。为此给 `PromptGenerator` 加了 `_skip_prompt_build` 参数——置 `True` 时只跑 `load_fragment()`（组装源码）就返回，跳过所有上下文加载和 prompt 构建，避免"只想要源码却白跑了全套检索"。

### 2.4 代码定位

| 文件 | 变更 |
|---|---|
| `src/java/translation/compositional_translation_validation.py` | 新增 `PSEUDOCODE_SYSTEM_PROMPT`、`_extract_pseudocode()`、`_generate_pseudocode()`；`translate()` 循环在构建 `PromptGenerator` 前先调一次 LLM 拿伪代码；新增 `--use_pseudocode` CLI flag |
| `src/java/translation/prompt_generator.py` | 新增 `pseudocode=""` 和 `_skip_prompt_build=False` 形参；新增 `add_pseudocode_bridge()` 方法；`build_base_prompt()` 在 Java 源码之后注入伪代码块 |
| `configs/prompt_templates.yaml` | 新增 `pseudocode_generation_system`、`pseudocode_generation_user`、`pseudocode_bridge_context` 模板 |

---

## 3. Part 2：Cangjie 语法 EBNF 注入（解决错误 B）

### 3.1 参考论文

| 论文 | 出处 | 核心思想 |
|---|---|---|
| **B2: Grammar Prompting for Domain-Specific Language Generation with Large Language Models** | Wang et al., ACL 2023 | 将目标语言的 BNF 语法规则作为 prompt 的一部分注入 LLM。**仅 prompt 注入（不需要约束解码）就显著提升语法正确率**，对 DSL/低资源语言效果最好 |
| **B1: DocCGen: Document-based Controlled Code Generation** | Pimparkhede et al., EMNLP 2024 | 两阶段：从文档检索相关库 → 从文档提取 grammar/schema 规则做约束解码。对 OOD（未见过库）场景效果显著——正是低资源语言的典型场景 |
| B5: SCD (Soft Constrained Decoding) | AAAI 2026 | 在解码时对非目标语言 token 施加软惩罚，解决语言漂移 |

**B2 是直接前身**——论文证明"仅把语法写进 prompt"就有效，不需要约束解码，完美适配我们用 API 调用 LLM 的场景。

### 3.2 论文原理

B2 的核心实验：

- 对 DSL（领域特定语言），LLM 训练数据中几乎没见过该语言。
- 方法：在 prompt 中注入目标语言的 BNF 语法规则（作为"中间变量"），让 LLM 在生成时参考。
- 生成时可选地用 Earley parser 做约束解码（只允许合法 token 序列），但实验发现 **不约束解码、仅在 prompt 中提供 grammar 就已经有显著提升**。
- 对 DSL 效果最好——因为 DSL 在训练数据中罕见，LLM 需要显式语法提示。

Cangjie 对 LLM 来说就是 DSL——训练数据极少，LLM 不知道 `where T <: Bound`、不知道 `Any` 不满足 `Hashable`、不知道 `Bool` 而非 `boolean`。

B1 补充：从文档提取 API schema 用于约束生成，在 OOD 场景效果显著。我们借用了"从文档提取规则"的思路，将 Cangjie 语法规则和 API 映射以结构化文本注入 prompt。

### 3.3 项目中的实现

新建模块 `src/java/translation/grammar_prompt.py`，提供 `get_grammar_prompt()` 返回一段固定的语法提示文本。该文本由两部分组成：

**第一部分：EBNF 语法摘要 + 8 条硬语义约束（G1-G8）**

```ebnf
# 类型与变量声明
var_decl      ::= "let" IDENT ":" TYPE "=" EXPR    # 不可变
              | "var" IDENT ":" TYPE "=" EXPR    # 可变
func_decl     ::= "func" IDENT "(" [ PARAMS ] ")" [ ":" TYPE ] "{" STMTS "}"
class_decl    ::= ("class" | "abstract class" | "open class") IDENT [ GENERICS ] [ ":" SUPERTYPES ] "{" MEMBERS "}"
GENERICS      ::= "<" TYPE_PARAM { "," TYPE_PARAM } ">"
TYPE_PARAM    ::= IDENT [ "where" IDENT "<:" TYPE ]
match_stmt    ::= "match" "(" EXPR ")" "{" { CASE "=>" BLOCK } "}"
```

8 条硬约束涵盖最常见的编译错误来源：

| 约束 | 内容 | 对应典型错误 |
|---|---|---|
| G1 | 泛型约束用 `where T <: Bound`，不用 extends/super，无通配符 | Java `? extends T` → Cangjie 无对应 |
| G2 | 型变用 `out T` / `in T`，不是 use-site `?` | Java 通配符 `? super T` |
| G3 | `Any` 不满足 `Hashable & Equatable<T>`，HashMap/HashSet 的 key/element 类型必须用 `AnyHashable` | `HashMap<Object, V>` → `HashMap<Any, V>` 编译报错 |
| G4 | 整数/浮点字面量需类型后缀，默认 `Int32`，建议显式 `Int64` | Java `int` 默认 32 位 |
| G5 | 布尔类型是 `Bool`（不是 `boolean`），可空标记 `?` | Java `boolean` → Cangjie `Bool` |
| G6 | 字符串插值 `"${expr}"`，不是 Java `String.format` | Java `"%" + x` |
| G7 | void 函数返回类型声明 `Unit` | Java `void` |
| G8 | 运算符重载用 `operator func`，相等性用 `func operator func ==` | Java `equals()` |

**第二部分：运行时 API 映射表**

```
Object (HashMap/HashSet key/elt)  -> AnyHashable
Runnable -> () -> Unit    Callable<V> -> () -> V    Function<T,R> -> (T) -> R
Consumer<T> -> (T) -> Unit    Supplier<T> -> () -> T
Predicate<T> -> (T) -> Bool    Comparator<T> -> (T, T) -> Int64
List<T> -> Array<T>    Map<K,V> -> HashMap<K,V>    Set<T> -> HashSet<T>
```

**关键设计决策**：

- **可编辑**：规则权威版放在 `configs/prompt_templates.yaml`（`cangjie_grammar_context` + `cangjie_grammar_runtime_note`），不写死代码——非工程师可直接编辑。代码内有 fallback 短版以防配置不可达。
- **缓存一次**：`get_grammar_prompt()` 单例懒加载，所有 fragment 共享同一块文本。
- **不做约束解码**：OpenAI API 不支持逐 token logits 访问，约束解码实现成本高。`cjpm build` 编译验证 + feedback 重试回路已经是 rejection sampling 的形态——编译失败时 LLM 在错误信号下自纠正。Grammar Prompt 是在现有架构下拿到增益的最低成本方式。

### 3.4 代码定位

| 文件 | 变更 |
|---|---|
| `src/java/translation/grammar_prompt.py` | 新模块：`build_grammar_prompt()`、`get_grammar_prompt()` 单例 + `reset_cache()`；从 YAML 加载，失败回退 inline fallback |
| `src/java/translation/prompt_generator.py` | import `get_grammar_prompt`；`__init__` 中当 `use_grammar_prompt == 'true'` 时加载；`build_base_prompt()` 在 instruction 之后、Java 源码之前注入 grammar 文本 |
| `configs/prompt_templates.yaml` | 新增 `cangjie_grammar_context`（EBNF + G1-G8）、`cangjie_grammar_runtime_note`（API 映射表） |

---

## 4. Part 3：语法图 RAG（CFG/DFG 结构相似检索）

Part 3 的核心是"用 Java fragment 的结构指纹，去 CangjieCorpus 里检索结构相似的 Cangjie 代码片段当 few-shot"。要查就先得有索引——syntax_graph_index.pkl 就是这个索引（12874 个 Cangjie 代码块的结构指纹库）。

### 4.1 参考论文

| 论文 | 出处 | 核心思想 |
|---|---|---|
| **B3: CodeGRAG: Extracting Composed Syntax Graphs for Retrieval Augmented Cross-Lingual Code Generation** | Huang et al., arXiv:2405.02355, 2024 | 从代码提取**组合语法图**（CFG + DFG 融合），用混合 GNN + 跨语言代码搜索模型计算相似度，检索结构相似的代码片段作为 few-shot。跨语言也有效（Python 代码辅助 C++ 生成） |
| B4: Syntax-Aware RAG | EMNLP 2023 Findings | 在 RAG 中引入语法感知——不只用语义相似检索，还用语法结构相似度 |
| B6: Cross-Lingual RAG | ACL 2026 Findings | 跨语言 RAG 代码生成：用一种语言的代码辅助另一种语言的生成 |

**B3 是直接前身**——论文用 CFG+DFG 做跨语言结构检索。我们做了实用化简化版。

### 4.2 论文原理

CodeGRAG 的完整流程：

1. **提取**：从代码中提取控制流图（CFG）和数据流图（DFG），融合为"组合语法图"——建模代码的固有流信息（语义级 + 逻辑级）。
2. **检索**：用混合 GNN 和预训练跨语言代码搜索模型计算相似度，从语料库中检索结构相似的代码块。
3. **注入**：检索到的语法图作为 LLM 的上下文，辅助生成。

关键发现：
- 语法图作为**跨语言桥梁**：不同语言的控制流和数据流结构相似，可跨语言检索。
- 单轮生成即可提升效果，不需要多次 prompt。
- 填补了"自然语言与编程语言之间的差距"和"不同编程语言之间的差距"。

### 4.3 项目中的实现

我们做了**实用化简化**：纯正则结构指纹 + Jaccard 相似度，无 NN/CUDA/额外依赖（CodeGRAG 的 GNN + 跨语言预训练模型需要大量基础设施）。

**为什么这个简化够用**：
- 我们只需要把翻译器"推向"结构大致匹配的 Cangjie 惯用片段，不要求精确 CFG 同构。
- 轻量提取让我们无需 Cangjie tree-sitter grammar（我们没有）就能索引 CangjieCorpus。
- 额外依赖为零（只需 pickle + pathlib + datasketch，后者已在 `environment.yaml`）。

**结构指纹设计**（`infer_structural_signature(code, category) -> StructSig`）：

对 Java 或 Cangjie 代码统一提取，语言无关（关键字 token 集合包含 Java 和 Cangjie 两种范式）：

| 维度 | 内容 | 桶化方式 |
|---|---|---|
| `shape_bag` | 12 个操作类别的计数 | 0=无, 1=1次, 2=2-4次, 3=≥5次 |
| `call_names` | 方法调用点标识符（去除控制流关键字） | 集合 |
| `container_types` | 命中常见集合类型名（list/array/map/set 等） | 集合 |
| `category` | corpus 目录粗分类（std/manual/extra） | 字符串 |

12 个操作类别：

```
cf_if, cf_loop, cf_switch_match, cf_return, cf_throw, cf_try_catch,
op_call, op_index, op_field_access, op_new_alloc, op_assign, op_lambda
```

**检索**：Jaccard 加权相似度 = `0.6 × shape_sim + 0.25 × call_sim + 0.15 × container_sim`，得分 <0.05 丢弃，只返回 top-3 真正相似的片段。

**索引构建**：扫描 `misc/CangjieCorpus` 下 `.cj / .cangjie / .cj.txt` 文件和 `.md` 中的 ```cangjie/cj``` 围栏代码块，pickle 序列化到 `data/java/rag/syntax_graph_index.pkl`。首次调用 `use_syntax_rag=true` 时若索引不存在会自动构建；也可用 `bash scripts/java/build_syntax_graph_index.sh` 预构建。

**与现有 RAG 的关系**：项目已有 `src/java/rag/` 语义检索（ChromaDB vector + BM25 + RRF），用于**文档级**检索（Cangjie 标准库 API 文档）。Part 3 是**结构级**检索，互补——原 RAG 回答"该用什么 API"，Part 3 回答"该写什么样的代码骨架"。

### 4.4 代码定位

| 文件 | 变更 |
|---|---|
| `src/java/rag/syntax_graph.py` | 新模块：`infer_structural_signature()`、`StructSig` dataclass、`build_syntax_graph_index()`、`_SyntaxGraphRAG` 单例 retriever、`get_syntax_graph_rag()` |
| `src/java/translation/prompt_generator.py` | import `get_syntax_graph_rag`；`__init__` 中在 `load_fragment()` 之后加载；`build_base_prompt()` 在 RAG 文档之后注入结构示例 |
| `tests/test_syntax_graph.py` | 4 个单测：提取器、跨语言相似、空代码、无索引退化 |
| `scripts/java/build_syntax_graph_index.sh` | 索引预构建脚本 |

---

## 5. 三部分如何组合工作

### 5.1 Prompt 注入顺序

三部分都在 `PromptGenerator.build_base_prompt()` 中注入，最终 prompt 按以下顺序组装：

```
persona                         ← 角色设定（cangjie-persona，含 AnyHashable 提示）
instruction                     ← 翻译任务指令
Cangjie EBNF grammar (Part 2)   ← 硬语法约束，在源码之前让模型先读规则
Java source code                ← 原始 Java fragment
pseudocode bridge (Part 1)      ← 语义桥梁，在源码之后让模型参照意图
partial Cangjie translation      ← 骨架（含已有依赖）
generics context                 ← 泛型规则库 C01-C45 匹配
Progressive KB few-shot          ← 历史成功翻译对照
RAG documentation                ← Cangjie 文档级语义检索
syntax graph examples (Part 3)  ← 结构相似 Cangjie 代码片段
ICL examples                     ← 自适应上下文学习
error feedback                   ← 编译错误反馈（仅重试时）
"### Response:"                  ← 输出标记
```

**设计逻辑**：grammar 在最前（先读规则再读代码）；伪代码在源码后（理解意图后再翻译）；结构示例在 RAG 文档后、ICL 前（作为"怎么写"的模板参考）。

### 5.2 翻译循环

```
for each fragment in traversal.json (按依赖顺序):
    if --use_pseudocode:
        Phase-1 LLM 调用: Java fragment → 伪代码块（带 // 自语注释）
    else:
        伪代码块 := ""
    PromptGenerator 构建完整 prompt（含 Part 1/2/3 注入）
    Phase-2 LLM 调用 → JSON {code, reasoning, imports}
    extract_json_translation() → 语法检查
    cjpm build 编译验证
    if 编译失败: feedback = 编译错误; 回到 PromptGenerator 重建带 feedback 的 prompt
    if 编译成功: (skip_mock=false 时) mock 测试 → 继续或回退
    记录 translation_status = success / fallback:*
```

### 5.3 CLI 开关

三个 flag 均默认 `"false"`，向后兼容。在 `translate_fragment.sh` 的第 9/10/11 位置参数：

```bash
bash scripts/java/translate_fragment.sh <project> <model> <suffix> <temp> \
    <use_rag> <skip_mock> <translate_tests> <use_progressive_kb> \
    <use_pseudocode> <use_grammar_prompt> <use_syntax_rag>
```

推荐组合：

| 场景 | use_pseudocode | use_grammar_prompt | use_syntax_rag |
|---|---|---|---|
| 仅修 Java→Cangjie API 模式继承错 | true | false | false |
| 不熟悉 Cangjie 语法（多为编译报语法错） | false | true | false |
| 需要 few-shot 结构模板 | false | false | true |
| **推荐起点**：同时解 A+B | true | true | false |
| 全开（贵但增益最高） | true | true | true |

---

## 6. 完整项目运行流程

### 6.0 环境

```bash
conda activate x2cangjie
export PYTHONPATH=$(pwd)
export OPENAI_API_KEY="sk-or-..."
export OPENAI_BASE_URL="https://openrouter.ai/api/v1"
# cjc / cjpm 必须手动安装并加入 PATH
# misc/ 下 tree-sitter-java/python v0.23.5、java-callgraph、CangjieCorpus 必须已 clone
# configs/model_configs.yaml 必须从 .example 拷贝并填好凭据
```

### 6.1 Java 侧预处理

```bash
bash scripts/java/preprocess.sh jansi
# 产物：projects/java/cleaned_final_projects[_evosuite_cleaned_base]/jansi/
```

### 6.2 Schema 生成

```bash
model=deepseek-chat; temp=0.0; suffix=_evosuite_cleaned_base
bash scripts/java/create_schema.sh jansi "$model" "$temp" "$suffix"
# 产物：data/java/schemas${suffix}/${model}/${temp}/jansi/*.json
```

### 6.3 依赖顺序

```bash
bash scripts/java/get_dependencies.sh jansi "$suffix"
# 产物：data/java/dependencies${suffix}/jansi/traversal.json
```

### 6.4 类型翻译

```bash
# 首次用 RAG 需先建索引
bash scripts/java/crawl_java_base.sh && python -m src.java.rag.indexer
bash scripts/java/translate_types.sh jansi "$model" "$temp" "$suffix" false true
```

### 6.5 骨架生成

```bash
bash scripts/java/create_skeleton.sh jansi "$model" "$suffix" "$temp"
# 产物：data/java/skeletons/jansi/src/*.cj（含 TODO 占位符）
```

### 6.6 Mock 语料

```bash
bash scripts/java/build_mock_corpus.sh jansi
# 产物：/tmp/cangjie_mock/jansi/
```

### 6.7 Fragment 翻译（三部分在此叠加）

```bash
# 基础（旧行为，全部新参数默认 false）
bash scripts/java/translate_fragment.sh jansi "$model" "$suffix" "$temp" \
    true true false true

# 全开三部分
bash scripts/java/translate_fragment.sh jansi "$model" "$suffix" "$temp" \
    true true false true \
    true true true

# 调试模式（tee 全部输出到 ./translate_debug.log）
bash debug.sh jansi "$model" "$suffix" "$temp" true false false true true true true
```

首次开 `use_syntax_rag=true` 时建议预建索引：

```bash
bash scripts/java/build_syntax_graph_index.sh misc/CangjieCorpus
# 产物：data/java/rag/syntax_graph_index.pkl + .jsonl
```

### 6.8 错误分析

```bash
bash scripts/java/analyze_errors.sh jansi "$model" "$temp" "$suffix"
# 产物：data/java/analysis/jansi_${model}_${temp}${suffix}_errors.txt
```

### 6.9 消融测试

```bash
# 一键跑 8 组（2^3 组合）+ 自动出对比报告
bash scripts/java/run_ablation.sh jansi "$model" "$suffix" "$temp" true true false true
# 产物：
#   data/java/ablation/jansi_<model>_<temp><suffix>/{baseline,pseudo,grammar,syntax,...}/
#   data/java/ablation/jansi_<model>_<temp><suffix>/report.md      ← 横向对比 + 显著性
#   data/java/ablation/jansi_<model>_<temp><suffix>/metrics.csv
#   data/java/ablation/jansi_<model>_<temp><suffix>/significance.csv
```

---

## 7. 新增/修改文件清单

### 新增文件

```
src/java/translation/grammar_prompt.py          # Part 2 模块
src/java/rag/syntax_graph.py                    # Part 3 模块
src/java/analysis/ablation_compare.py           # 消融对比分析
scripts/java/build_syntax_graph_index.sh        # Part 3 索引构建
scripts/java/run_ablation.sh                    # 一键消融 sweep
tests/test_grammar_prompt.py                    # Part 2 单测
tests/test_syntax_graph.py                      # Part 3 单测
tests/test_ablation_compare.py                  # 消融分析单测
docs/related_work_code_translation.md           # 15 篇论文详细摘要
docs/fragment_translation_enhancements.md       # 实现细节 + 消融使用说明
docs/work_report.md                             # 本文档
```

### 修改文件

```
src/java/translation/compositional_translation_validation.py   # Part 1 + 3 个新 CLI flag
src/java/translation/prompt_generator.py                      # Part 1/2/3 注入点
configs/prompt_templates.yaml                                 # Part 1/2 新模板
scripts/java/translate_fragment.sh                            # 3 个新位置参数
AGENTS.md                                                     # 新 flags 概述
```

### 未修改的文件

```
src/java/analysis/analyze_errors.py    # 旧分析工具，消融代码 import 它但不改它
scripts/java/analyze_errors.sh         # 旧分析脚本，仍可独立使用
```

---

## 8. 消融测试说明

### 8.1 为什么需要消融

A6（Assessing Intermediate Languages, arXiv:2407.05411）警告：伪代码中间层的收益可能部分来自 CoT 多步推理效应（多步 > 单步），而非伪代码本身的语言中立性。因此需要 ablation 分离每部分的增量来源。

### 8.2 消融设计

8 种 run-tag（2^3 = 8）：

| run-tag | use_pseudocode | use_grammar_prompt | use_syntax_rag |
|---|---|---|---|
| baseline | false | false | false |
| pseudo | true | false | false |
| grammar | false | true | false |
| syntax | false | false | true |
| pseudo+grammar | true | true | false |
| pseudo+syntax | true | false | true |
| grammar+syntax | false | true | true |
| all | true | true | true |

### 8.3 关键设计

- **必须 snapshot**：`translate_fragment.sh` 每次覆盖同一份 schema JSON，后跑的会覆盖前跑的统计数据。因此每组运行后必须把 schema 目录拷贝到独立的 `data/java/ablation/<run-tag>/` 子目录。`run_ablation.sh` 自动做了这件事。
- **skeleton 同步重建**：每组前先 `create_skeleton.sh` 重建骨架，保证翻译基线一致。
- **复用既有指标**：消融代码 import `analyze_project()` 读取 statistics 字段，不改旧文件。
- **Fisher exact 自实现**：不能依赖 scipy（未在 `environment.yaml`），用纯 Python `lgamma` + hypergeometric 求和实现 2×2 双侧 p 值。

### 8.4 产出指标

| 指标 | 含义 | 期望方向 |
|---|---|---|
| completed / completed_rate | translation_status == 'completed' | ↑ |
| compiled_pass / compiled_pass_rate | cangjie_compilation.outcome == 'success' | ↑ |
| test_pass / test_pass_rate_of_compiled | 测试通过 / 编译通过池 | ↑ |
| residual_todos / residual_todos_per_file | .cj 中残留 TODO 计数 | ↓ |
| elapsed_mean_s | 平均每 fragment 耗时 | 视情况 |

报告含：8-run 总览表 + Δ vs baseline 表 + per-part 独立效应段 + 显著性表（Fisher exact, p<0.05 标 ✓）+ pairwise 两-part 组合表。

### 8.5 运行

```bash
# 一键（推荐）
bash scripts/java/run_ablation.sh jansi deepseek-chat _evosuite_cleaned_base 0.0 true true false true

# 手动分析已有快照
python -m src.java.analysis.ablation_compare \
    --project jansi --model deepseek-chat --temperature 0.0 \
    --suffix _evosuite_cleaned_base \
    --ablation-root data/java/ablation/jansi_deepseek-chat_0.0_evosuite_cleaned_base

# 单测
python -m pytest tests/test_grammar_prompt.py tests/test_syntax_graph.py tests/test_ablation_compare.py -v
```

---

## 9. 已知限制与后续可改进项

1. **Part 1 可优 ablation**：建议对比 (a) 直接翻译、(b) CoT 先分析再翻译、(c) 伪代码中间层，分离 CoT 效应与伪代码语言中立性的增量来源。
2. **Part 2 未启用约束解码**：`cjpm build` 编译错误信号已实现 rejection sampling，但 logit-bias 近似约束未做——后续可引入。
3. **Part 3 同构判断粗糙**：纯正则 + Jaccard 是对 CodeGRAG 的简化版；若需更强，可接 tree-sitter-java 解析 + 真实 CFG/DFG + 跨语言预训练代码搜索模型。
4. **未做端到端评估**：代码已接通并写了单测，但未在配置实际 LLM 与 `cjpm` 的 Docker 环境中跑端到端实测——需运行消融测试并通过 `report.md` 统计 fragment 通过率增量以实证每部分收益。
5. **temperature 建议 0.0**：消融时温度不为 0 每次跑都不同，单次"增益"可能在噪声范围内。温度升高需多跑几轮取期望。

---

## 10. 论文索引速查

| ID | 论文 | 方向 | 关键词 | 相关度 | 对应 Part |
|----|-------|------|--------|--------|-----------|
| A1 | Pseudocode-based Code Translation (arXiv 2510.00920) | A | 伪代码中间层、语义翻译 | ★★★★★ | Part 1 |
| A3 | NL in the Middle (CASCON 2025) | A | NL summary、CoT | ★★★★☆ | Part 1 设计依据 |
| A4 | Unraveling LLM Code Translation (arXiv 2410.09812) | A | 风格转换、中间语言 | ★★★★☆ | Part 1 互补思路 |
| A6 | Assessing Intermediate Languages (arXiv 2407.05411) | A | 中间语言评估、CoT | ★★★☆☆ | Part 1 ablation 依据 |
| B2 | Grammar Prompting (ACL 2023) | B | BNF grammar、约束解码 | ★★★★★ | Part 2 |
| B1 | DocCGen (EMNLP 2024) | B | 文档约束解码、API schema | ★★★★★ | Part 2 补充 |
| B3 | CodeGRAG (arXiv 2405.02355) | B | 语法图、跨语言 RAG | ★★★★☆ | Part 3 |
| B4 | Syntax-Aware RAG (EMNLP 2023 Findings) | B | 语法感知检索 | ★★★☆☆ | Part 3 补充 |
| A2 | INTERTRANS (ICSE 2025) | A | 传递性翻译、中间语言 | ★★★☆☆ | 未采用（参考） |
| A5 | TIT (arXiv 2510.09400) | A | 树结构指令微调 | ★★★☆☆ | 未采用（需微调） |
| A7 | CoTran (arXiv 2306.06755) | A | Back-translation | ★★☆☆☆ | 未采用（需训练） |
| A8 | TransCoder-IR (ICLR 2023) | A | LLVM IR | ★★☆☆☆ | 未采用（Cangjie 无 LLVM IR） |
| A9 | PseudoBridge (arXiv 2509.20881) | A | 伪代码、代码检索 | ★★☆☆☆ | 未采用（检索非翻译） |
| B5 | SCD (AAAI 2026) | B | 语言漂移、软约束解码 | ★★★☆☆ | 未采用（需 logits 访问） |
| B6 | Cross-Lingual RAG (ACL 2026 Findings) | B | 跨语言 RAG | ★★★☆☆ | 未采用（参考） |

---

## 11. 同组同学快速上手指南

### 11.1 先读什么

1. **本文档** — 整体了解三部分做了什么、为什么、怎么跑
2. `docs/start.md` — 项目原有 pipeline 的搭建步骤
3. `docs/fragment_translation_enhancements.md` — 实现细节和 CLI 参数完整说明
4. `docs/related_work_code_translation.md` — 15 篇论文的详细摘要（需要深入某一部分时再看对应论文）

### 11.2 关键代码文件

| 想了解 | 读这个文件 |
|---|---|
| 翻译主循环怎么跑的 | `src/java/translation/compositional_translation_validation.py` 的 `translate()` 函数 |
| prompt 怎么组装的 | `src/java/translation/prompt_generator.py` 的 `build_base_prompt()` 方法 |
| Part 1 伪代码怎么生成的 | 同上文件 `_generate_pseudocode()` 函数 |
| Part 2 语法规则长什么样 | `configs/prompt_templates.yaml` 搜 `cangjie_grammar_context` |
| Part 3 结构指纹怎么提取的 | `src/java/rag/syntax_graph.py` 的 `infer_structural_signature()` 函数 |
| 消融报告怎么生成的 | `src/java/analysis/ablation_compare.py` 的 `main()` 函数 |

### 11.3 快速验证

```bash
# 单测（不需要 Cangjie SDK / LLM，纯单元）
conda activate x2cangjie
export PYTHONPATH=$(pwd)
python -m pytest tests/test_grammar_prompt.py tests/test_syntax_graph.py tests/test_ablation_compare.py -v

# 端到端跑一个项目（需要完整环境）
bash scripts/java/translate_fragment.sh jansi deepseek-chat _evosuite_cleaned_base 0.0 \
    true true false true true true true

# 看结果
bash scripts/java/analyze_errors.sh jansi deepseek-chat 0.0 _evosuite_cleaned_base
cat data/java/analysis/jansi_deepseek-chat_0.0_evosuite_cleaned_base_errors.txt
```

### 11.4 调试 prompt

在 `compositional_translation_validation.py` 的 `translate()` 函数中，`log_detail(args, "PROMPT", prompt)` 会把完整 prompt 打到 body log（`{project}_{model}_body.log`）。用 `bash debug.sh ...` 会 tee 全部输出到 `./translate_debug.log`。搜索 `PSEUDOCODE` 可以看 Phase-1 生成的伪代码内容，搜索 `PROMPT` 可以看最终发给 LLM 的完整 prompt（含 Part 1/2/3 注入后的版本）。
