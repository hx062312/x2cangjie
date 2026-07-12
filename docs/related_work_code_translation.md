# Fragment 翻译优化：相关工作调研

> 目标：解决 fragment 翻译中的两类错误——(A) 错误继承 Java 源语法/API 模式；(B) 使用错误的 Cangjie 语法/API。
>
> - **方向 A**：引入伪代码中间层（配合注释），将 Java fragment 先转为语言无关的伪代码表示，再基于伪代码 + metadata 翻译到 Cangjie。
> - **方向 B**：将 Cangjie 语法/API 知识更有效地注入 LLM 翻译过程。

---

## 方向 A：伪代码 / 中间表示作为翻译桥梁

### A1. Can Emulating Semantic Translation Help LLMs with Code Translation? A Study Based on Pseudocode
- **论文**: arXiv:2510.00920, 2025
- **作者**: Songqiang Chen, Congying Xu, Jingyi Chen, Jialun Cao, Jia-Rong Wu, Shing-Chi Cheung
- **代码**: https://github.com/imcsq/Pseudocode-based-Code-Translation
- **核心方法**:
  - 模拟人类自然语言翻译中的"语义翻译"策略：当源语言和目标语言语法差异大时，先理解源代码的意图和逻辑，用伪代码表达，再基于伪代码生成目标代码。
  - 两阶段：`Source Code → Pseudocode → Target Code`，而非直接 `Source → Target`。
  - 伪代码由 LLM 自动生成，带有对代码意图和逻辑的自然语言描述。
- **关键发现**:
  - 直接翻译时，LLM 倾向于模仿源代码的实现方式，即使目标语言不支持该模式。例如 Python 的 for-loop lambda 在 Java 中会被强行模仿，导致语义错误。
  - 通过伪代码中间层，LLM 先抽象出意图，再用目标语言的惯用方式实现，显著提升了翻译正确率。
  - 测试了 5 种策略组合：仅伪代码、伪代码 + 源代码、伪代码 + 源代码 + 反馈等，不同策略各有优势。
  - 支持六种语言：Python, JavaScript, Java, C++, Go, Rust。
- **与我们场景的关联度**: ★★★★★
  - **几乎完全就是我们设想的方法**。可以直接参考其 prompt 模板设计（GitHub 有完整的 replication package）。
  - 他们的实验验证了伪代码中间层对于"源语言语法继承"问题确实有效。
  - **局限**：他们是在主流语言对（Py→Java 等）上测试的，Cangjie 作为新语言训练数据稀缺，伪代码到 Cangjie 的生成质量可能受限——需要结合方向 B 的知识注入。

### A2. INTERTRANS: Leveraging Transitive Intermediate Translations to Enhance LLM-based Code Translation
- **论文**: arXiv:2411.01063, ICSE 2025
- **作者**: Marcos Macedo, Yuan Tian, Pengyu Nie, Filipe R. Cogo, Bram Adams
- **核心方法**:
  - 不使用伪代码，而是用现有编程语言作为"桥梁"：`Source → Intermediate PL → Target PL`。
  - 构建翻译树（Tree of Code Translations），系统探索所有可能的中转语言路径（如 Python→Go→Java）。
  - 每条路径生成候选翻译，用测试套件验证，取第一个通过的。
  - 超参数 `maxDepth` 控制最大中转次数。
- **关键发现**:
  - 传递性翻译在某些语言对上显著优于直接翻译，但最优中转语言因语言对和代码片段而异。
  - Go 作为中间语言整体表现最好（被称为编程语言界的 "lingua franca"）。
- **与我们场景的关联度**: ★★★☆☆
  - 启发：对 Java→Cangjie，可以考虑 Java→伪代码→Cangjie（类似 A1），也可以考虑 Java→Python/Go→Cangjie 的两跳翻译。
  - 但 Cangjie 缺少测试套件来验证候选翻译，限制了多路径投票的可行性。我们已有 `cjpm build` 编译验证，可部分替代。

### A3. NL in the Middle: Code Translation with LLMs and Intermediate Representations
- **论文**: CASCON 2025, arXiv:2507.08627
- **作者**: Chi-en Amy Tai, Pengyu Nie, Lukasz Golab, A.M.C. Wong
- **核心方法**:
  - 系统对比多种中间表示：自然语言摘要（NL summary）、AST、NL + AST 组合。
  - 多种集成方式：zero-shot、one-shot、chain-of-thought (CoT)。
  - 在 CodeNet 和 AVATAR 基准上测试。
- **关键发现**:
  - CoT + NL summary 作为中间表示效果最好，比 zero-shot 提升 13.8%（CodeNet）和 6.7%（AVATAR）。
  - AST 作为中间表示效果不如 NL——可能因为 AST 的结构化信息对 LLM 不如自然语言直觉。
  - **自然语言中间表示比结构化中间表示更有效**。
- **与我们场景的关联度**: ★★★★☆
  - 支持"用自然语言/伪代码做中间层"的设计选择。
  - 提示我们：伪代码 + 注释（自然语言）可能比纯 AST 结构更适合作为中间层。
  - CoT 式的 prompt 设计（先生成中间表示，再生成目标代码）比简单 one-shot 更强。

### A4. Unraveling the Potential of LLMs in Code Translation: How Far Are We?
- **论文**: arXiv:2410.09812, 2024
- **核心方法**:
  - 提出两种改进方案：
    1. **风格转换（Style Transfer）**：先让 LLM 将源代码转换为接近目标语言风格的中间形式。例如 Py→Java 时先转成纯过程式风格（去掉 list comprehension 和函数式 API）。
    2. **中间语言（Intermediary Language）**：用第三语言作为桥梁，类似 A2。
  - 还提出 **自训练（self-training）** 方法增强效果。
- **关键发现**:
  - 中间翻译技术（含风格转换和中间语言）整体效果显著提升。
  - Go 作为中间语言效果最好。
  - **风格转换**特别有价值：它不是换语言，而是先去掉源语言的特有模式，使中间结果更容易翻译。
  - 组合使用中间翻译 + 自训练达到最佳。
- **与我们场景的关联度**: ★★★★☆
  - "风格转换"这一思路很适合 Java→Cangjie：先将 Java fragment 去掉 Java 特有模式（如匿名类、流式 API、checked exception 等），转成更"朴素"的中间表示，再翻译到 Cangjie。
  - 这与伪代码方案互补：伪代码更激进（完全去掉语法），风格转换更温和（保留代码结构但去掉惯用法）。

### A5. TIT: A Tree-Structured Instruction Tuning Approach for LLM-Based Code Translation
- **论文**: arXiv:2510.09400, 2025
- **作者**: He Jiang, Yufu Wang 等
- **核心方法**:
  - 针对 LLM 翻译的两大问题：(1) 源语言语法/词法泄漏到目标代码（syntactic confusion）；(2) 缺乏细粒度语义对齐。
  - 三模块：语言无关的语法信息表示模块 + 语句级并行数据增强 + 双阶段树结构指令微调。
  - 第一阶段：语法感知微调，让 LLM 理解结构化语法信息。
  - 第二阶段：代码生成微调，基于函数级语法依赖生成目标代码。
- **关键发现**:
  - 成功率比现有方法高 1.22x–1.75x，显著减少语法混淆。
  - **"语言无关的语法特征"**是关键——通过 AST 解析提取语法结构，使其不绑定到任何语言。
- **与我们场景的关联度**: ★★★☆☆
  - 需要微调模型，我们目前用 API 调用不便直接应用。
  - 但"语言无关语法特征"的思路可借鉴：用 tree-sitter 提取 Java fragment 的 AST 结构，作为伪代码的一部分注入 prompt。

### A6. Assessing Code Generation with Intermediate Languages
- **论文**: arXiv:2407.05411, 2024
- **作者**: Xun Deng 等
- **核心方法**:
  - 系统评估多种中间语言（C++, Go, Java, Python, Rust, 自然语言, 伪代码）对代码生成的影响。
  - 11 个模型（CodeLlama, GPT, Mistral）参与实验。
- **关键发现**:
  - **自然语言**作为中间表示在所有目标语言上效果最好。
  - 没有通用最优的形式中间语言——效果因模型和目标语言而异。
  - 中间解法的正确性与最终生成质量只有弱相关——提升更像 CoT 效应而非语言特异传递。
  - 对 GPT 系列，多次采样（无明确自纠正指令）也能提升性能。
- **与我们场景的关联度**: ★★★☆☆
  - 重要警示：伪代码中间层的收益可能部分来自 CoT 效应（多步推理 > 单步），而非伪代码本身的语言中立性。
  - 建议同时测试"自然语言描述 + 伪代码"的组合。

### A7. CoTran: Compiler-Feedback Guided Back-Translation for Code Translation
- **论文**: arXiv:2306.06755, 2023
- **核心方法**:
  - 两个背靠背 LLM：Java→Python 和 Python→Java，联合训练。
  - 用编译器反馈和符号执行反馈训练 back-translation（S→T→S），确保翻译等价性。
  - 三种 loss：交叉熵 + 编译反馈 + 符号执行反馈。
- **与我们场景的关联度**: ★★☆☆☆
  - 需要训练模型，不适合直接应用。
  - 但 **编译器反馈指导翻译** 的思路与我们的 `cjpm build` 验证循环一致——编译错误反馈可用于改进翻译。

### A8. TransCoder-IR: Code Translation with Compiler Representations
- **论文**: ICLR 2023, arXiv:2207.03578
- **作者**: Marc Szafraniec, Baptiste Rozière 等（Meta）
- **核心方法**:
  - 使用 LLVM IR 作为语言无关的中间表示。
  - C++, Go, Java, Rust 都可以编译到 LLVM IR，实现跨语言对齐。
  - 三个训练目标：TLM（翻译语言模型）、MLM（遮蔽语言模型）、DOBF（去混淆）。
- **与我们场景的关联度**: ★★☆☆☆
  - Cangjie 没有编译到 LLVM IR 的能力（cjc 不是基于 LLVM 的），无法直接使用。
  - 但思路启发：如果有一个类似于 IR 的"低级表示"，可以作为语言无关的桥梁。

### A9. PseudoBridge: Pseudo Code as the Bridge for Better Semantic and Logic Alignment in Code Retrieval
- **论文**: arXiv:2509.20881, 2025
- **核心方法**:
  - 将伪代码作为代码检索的语义桥梁——查询和代码都先转成伪代码，在伪代码空间做匹配。
- **与我们场景的关联度**: ★★☆☆☆
  - 面向代码检索而非翻译，但验证了伪代码作为跨语言语义桥梁的有效性。

---

## 方向 B：注入目标语言语法/API 知识

### B1. DocCGen: Document-based Controlled Code Generation
- **论文**: EMNLP 2024, arXiv:2406.11925
- **作者**: Sameer Pimparkhede 等
- **核心方法**:
  - 两阶段框架：
    1. **信息检索**：从文档库中检索相关的库/文档。
    2. **约束解码**：从检索到的文档中提取 grammar/schema 规则，在贪婪解码时约束 LLM 只生成符合规则的 token。
  - 具体：从文档提取 API 的 template（如 `gh <command> <subcommand> [flags]`），在解码时用 Earley parser 约束 token 选择，不符合 grammar 的 token logits 设为 -∞。
  - 分 In-domain 和 Out-of-domain 两种设置评估。
- **关键发现**:
  - 对 OOD（未见过库）场景效果显著——这正是低资源目标语言的典型场景。
  - 文档提取的 grammar 规则有效约束了生成，避免了不存在的 API 调用。
- **与我们场景的关联度**: ★★★★★
  - **直接解决问题 B**：Cangjie 是低资源语言，LLM 训练数据中几乎没有 Cangjie 代码。从 Cangjie 官方文档提取 API signature 和语法规则，约束生成。
  - **约束解码**需要访问模型 logits，如果用 OpenAI API 可能受限。但可以用 candidate sampling 或 rejection sampling近似实现——生成多个候选，只保留编译通过的。
  - 我们已有 RAG 检索 Cangjie 文档，但只是将文档拼到 prompt 里。DocCGen 的思路更进一步：从文档提取结构化规则，在生成时做硬约束。

### B2. Grammar Prompting for Domain-Specific Language Generation with Large Language Models
- **论文**: ACL 2023, arXiv:2305.19234
- **作者**: Bailin Wang 等（Google）
- **核心方法**:
  - 将目标语言的 BNF 语法规则作为 prompt 的一部分注入 LLM。
  - 生成时用 Earley parser 约束解码——只允许合法 token 序列。
  - 适配 API-only LLM 的策略：speculative decoding，先让 LLM 生成完整程序，再用 parser 检查；不合法则截断到第一个错误点重新生成。
- **关键发现**:
  - 即使不约束解码（仅在 prompt 中提供 grammar），效果也显著提升。
  - 约束解码可以保证语法正确性，但需要 LLM 支持每步 logits 访问。
  - Grammar prompt 对 DSL（领域特定语言）效果最好——DSL 在训练数据中罕见。
- **与我们场景的关联度**: ★★★★★
  - Cangjie 对 LLM 来说就是 DSL（训练数据极少）。将 Cangjie 的关键语法规则（如 `where T <: UpperBound` 泛型约束、`~T` 投影、Hashable 约束等）以 grammar prompt 形式注入。
  - **不需要约束解码也能获益**——仅把语法规则写进 prompt 就有效。这非常适合我们用 API 调用 LLM 的场景。
  - 我们的 generics_rule_lib（C01–C45 规则）本质就是在做这件事，但可以更系统化——将 Cangjie 语法 grammar 以 BNF/EBNF 形式注入 prompt。

### B3. CodeGRAG: Extracting Composed Syntax Graphs for Retrieval Augmented Cross-Lingual Code Generation
- **论文**: arXiv:2405.02355, 2024
- **核心方法**:
  - 从代码中提取**组合语法图（Composed Syntax Graph）**：融合数据流图（DFG）和控制流图（CFG）。
  - 提取的结构化知识建模了代码块的固有流信息。
  - 用混合 GNN 和跨语言代码搜索模型计算相似度，检索相关结构。
  - 检索到的语法图作为 LLM 的上下文，辅助生成。
- **关键发现**:
  - 语法图作为跨语言桥梁：不同语言的控制流和数据流结构相似，可跨语言检索。
  - 对跨语言代码生成（如用 Python 代码辅助生成 C++）也有增益。
  - 单轮生成即可提升效果，不需要多次 prompt。
- **与我们场景的关联度**: ★★★★☆
  - 可以从 CangjieCorpus 中的正确 Cangjie 代码提取语法图，建立索引。
  - 翻译 Java fragment 时，从中检索结构相似的 Cangjie 代码片段作为 few-shot 示例。
  - 与我们的 Progressive KB 互补：Progressive KB 索引的是翻译对照对，CodeGRAG 索引的是结构化的语法/数据流图。

### B4. Syntax-Aware Retrieval Augmented Code Generation
- **论文**: EMNLP 2023 Findings
- **核心方法**:
  - 在 RAG 代码生成中引入语法感知——不只用语义相似检索，还用语法结构相似度。
  - 从代码库中检索与目标语法模式匹配的代码片段。
- **与我们场景的关联度**: ★★★☆☆
  - 启发：我们的 RAG 目前是语义检索 Cangjie 文档，可以增加语法模式检索——根据 Java fragment 的语法特征（如循环+条件+赋值）检索具有相似结构的 Cangjie 代码。

### B5. Soft Constrained Decoding (SCD) for Language Drift
- **论文**: AAAI 2026 Oral, arXiv:2511.09984
- **代码**: https://github.com/WisdomShell/SCD
- **核心方法**:
  - 针对多语言 RAG 中语言漂移（language drift）问题——模型生成时混入非目标语言 token。
  - 在解码时对非目标语言 token 施加软惩罚（soft penalty），提升目标语言 token 的概率。
  - 模型无关、无需训练，集成到标准解码流程。
  - 三类 token 划分：目标语言 token（boost）、干扰语言 token（penalty）、中性 token（不干预）。
- **与我们场景的关联度**: ★★★☆☆
  - Java→Cangjie 翻译中的语法混淆（syntactic confusion）本质上是一种"语言漂移"——Java 语法模式混入 Cangjie 输出。
  - 如果能区分 Cangjie token 和 Java token，可以在解码时惩罚 Java 模式。
  - **局限**：需要访问模型 logits，OpenAI API 场景下需要用 logit_bias 参数近似实现。

### B6. Across Programming Language Silos: A Study on Cross-Lingual Retrieval-Augmented Code Generation
- **论文**: ACL 2026 Findings
- **核心方法**:
  - 研究跨语言 RAG 代码生成：用一种语言的代码片段辅助另一种语言的生成。
  - 对比多种设置：oracle 检索 vs 实际模型检索、有/无自然语言描述、多语言 LLM vs Python 专用 LLM。
  - 评估 CodeLlama, Deepseek-Coder, Qwen2.5-Coder 等。
- **关键发现**:
  - 跨语言 RAG 对多语言 LLM 有效，但对专用 LLM 效果有限。
  - 检索到的代码即使没有自然语言注释也有增益。
  - 检索质量是瓶颈——非 oracle 检索的效果显著下降。
- **与我们场景的关联度**: ★★★☆☆
  - 启发：用 CangjieCorpus 中的正确代码作为 RAG 资源时，检索质量是关键。
  - 可以考虑用 Java fragment 先转伪代码，再从 CangjieCorpus 中检索语义相似的 Cangjie 代码。

---

## 综合分析与建议

### 两个方向的关系

方向 A（伪代码中间层）和方向 B（目标语言知识注入）是**互补而非替代**关系：

```
当前流程:  Java fragment → [RAG + Progressive KB + Generics Rules] → LLM → Cangjie

集成方向 A + B:
  Java fragment → LLM → 伪代码 + 语义注释（语言无关）
                    ↓
  伪代码 + [Cangjie 语法 rules/API docs/语法图 RAG/few-shot] → LLM → Cangjie
                    ↓
  cjpm build 验证 → 编译错误反馈 → 修正重试
```

- **方向 A** 解决"错误继承 Java 语法"问题——伪代码层剥离了 Java 特有模式。
- **方向 B** 解决"不熟悉 Cangjie 语法"问题——注入的知识让 LLM 生成正确的 Cangjie。
- 两者可以叠加：基于伪代码翻译时同时注入 Cangjie 知识。

### 具体落地建议

#### 第一优先级：伪代码中间层（方向 A，参考 A1）

1. **Prompt 设计**（直接复用 A1 的 GitHub replication package 的模板）：
   - Phase 1 prompt：`Java code → Pseudocode with semantic annotations`
   - Phase 2 prompt：`Pseudocode + Cangjie metadata → Cangjie code`

2. **伪代码格式优化**（综合 A3 和 A6 的发现）：
   - 自然语言中间表示效果最好（A3, A6），所以伪代码应该**偏自然语言、而非偏代码**：
     ```
     // 意图：遍历列表，过滤出长度大于3的元素
     // 逻辑：
     //   for each element in list:
     //     if element.length > 3:
     //       add to result
     //   return result
     ```
   - 带注释而非纯结构化伪代码——A3 证明 NL summary > AST。

3. **Prompt 中同时包含源代码**（A1 的 Strategy 4/5）：
   - A1 发现"伪代码 + 源代码"比"仅伪代码"更好——LLM 可以参照源代码解决伪代码中的歧义。
   - 即 Phase 2 prompt = `[源 Java fragment, 伪代码, Cangjie rules/API docs] → Cangjie code`

4. **风险控制**（A6 的警示）：
   - 伪代码层的收益可能部分来自 CoT 效应（多步推理 > 单步），而非伪代码本身的中立性。
   - 建议做 ablation：对比 (a) 直接翻译，(b) CoT 先分析再翻译，(c) 伪代码中间层，看增量来自哪里。

#### 第二优先级：Grammar Prompt 注入（方向 B，参考 B2）

1. **将 Cangjie 关键语法以 EBNF 形式注入 prompt**（B2 证明仅 prompt 注入就有效，不需要约束解码）：
   ```
   Cangjie 语法规则（摘录）:
   - 泛型约束: where T <: UpperBound
   - 可变类型参数: out T / in T
   - 类型投影: ~T
   - Hash 容器约束: Hashable & Equatable<T>
   - 变量声明: let x: Int64 = 0 (不可变) / var x = 0 (可变)
   - 函数声明: func name(a: Int64, b: String): Bool { ... }
   ```

2. **从 Cangjie 官方文档自动提取 API schema**（B1 DocCGen 的思路）：
   - 解析 Cangjie 文档中的 API signature → 生成 schema 模板。
   - 检索与当前 fragment 相关的 API 文档 + schema。
   - 尝试用 OpenAI 的 `logit_bias` 参数做近似约束（对不合法 API token 施加负 bias）。

#### 第三优先级：语法图 RAG（方向 B，参考 B3 CodeGRAG）

1. **从 CangjieCorpus 提取语法图**：
   - 解析 CangjieCorpus 中的正确代码，提取 CFG + DFG。
   - 建立语法图索引，按结构特征聚类。
2. **翻译时检索**：
   - 从 Java fragment 提取 CFG + DFG（我们已有 tree-sitter-java）。
   - 检索结构相似的 Cangjie 语法图，作为 few-shot 示例注入 prompt。
   - 这与 Progressive KB 互补：KB 索引翻译对照对，语法图 RAG 索引结构模式。

#### 不建议立即采用

- **约束解码**（B1, B2 中的 Earley parser 方案）：需要逐 token 访问 logits，OpenAI API 支持有限，实现成本高。用 `cjpm build` 编译验证 + rejection sampling 近似替代。
- **模型微调**（A5 TIT, A7 CoTran）：需要训练资源和大规模并行数据，与当前 API 调用架构不匹配。
- **LLVM IR 中间表示**（A8 TransCoder-IR）：Cangjie 不编译到 LLVM IR，无法使用。但思路有价值——如果未来 Cangjie 编译器输出某种 IR，可以考虑。
- **传递性语言翻译**（A2 InterTrans）：Java→Python→Cangjie 两跳翻译理论上可行，但每跳引入误差，且 Cangjie API 知识在中间语言不可用，不如伪代码中间层直接。

---

## 论文索引速查

| ID | 论文 | 方向 | 关键词 | 相关度 |
|----|-------|------|--------|--------|
| A1 | Pseudocode-based Code Translation (arXiv 2510.00920) | A | 伪代码中间层、语义翻译 | ★★★★★ |
| A2 | INTERTRANS (ICSE 2025) | A | 传递性翻译、中间语言 | ★★★☆☆ |
| A3 | NL in the Middle (CASCON 2025) | A | NL summary、AST、CoT | ★★★★☆ |
| A4 | Unraveling LLM Code Translation (arXiv 2410.09812) | A | 风格转换、中间语言 | ★★★★☆ |
| A5 | TIT (arXiv 2510.09400) | A | 树结构指令微调、语法混淆 | ★★★☆☆ |
| A6 | Assessing Intermediate Languages (arXiv 2407.05411) | A | 中间语言评估、CoT | ★★★☆☆ |
| A7 | CoTran (arXiv 2306.06755) | A | Back-translation、编译反馈 | ★★☆☆☆ |
| A8 | TransCoder-IR (ICLR 2023) | A | LLVM IR、跨语言对齐 | ★★☆☆☆ |
| A9 | PseudoBridge (arXiv 2509.20881) | A | 伪代码、代码检索 | ★★☆☆☆ |
| B1 | DocCGen (EMNLP 2024) | B | 文档约束解码、API schema | ★★★★★ |
| B2 | Grammar Prompting (ACL 2023) | B | BNF grammar、约束解码 | ★★★★★ |
| B3 | CodeGRAG (arXiv 2405.02355) | B | 语法图、跨语言 RAG | ★★★★☆ |
| B4 | Syntax-Aware RAG (EMNLP 2023 Findings) | B | 语法感知检索 | ★★★☆☆ |
| B5 | SCD (AAAI 2026) | B | 语言漂移、软约束解码 | ★★★☆☆ |
| B6 | Cross-Lingual RAG (ACL 2026 Findings) | B | 跨语言 RAG 代码生成 | ★★★☆☆ |