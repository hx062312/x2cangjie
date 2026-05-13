我已经把 start.md、mock.sh / runtime.sh / run.sh / log_tests.sh / instrument.sh 以及 compositional_translation_validation.py 都过了一遍。整合之前有一堆决策点没拍板，我罗列出来逐个确认（按重要性排序），你逐条回我即可。

1. 翻译目标目录与 mock 测试目录的脱节（最关键）
   主流程把骨架和翻译写到 data/java/skeletons/<project>/src/，而 mock 流程的 cjpm test 跑在 projects/cangjie/original_projects/<project>/。两者不是同一个 cangjie 工程：

选项 A：mock 测试改跑 data/java/skeletons/<project>/（需要那里也有 cjpm.toml + helper/simple_ioc 注入），翻译刚 emit 的代码就能立刻被验证。
选项 B：每个 fragment 编译通过后，把骨架对应的 .cj 同步拷到 projects/cangjie/original_projects/<project>/src/ 再跑 mock。
选项 C：把 projects/cangjie/original_projects/<project> symlink/视作翻译产物目录，统一一处。
→ 选哪个？你之前手动跑 mock 时，被测的 cangjie 代码是从哪儿来的？

2. 触发粒度与时机
   translate() 现在每个 fragment 编译通过后就 break（test 方法直接 return）。mock 测试要插在哪一层：

(a) 每个非 test-method fragment 编译通过后立刻跑 —— 每改一行就跑测试，反馈最即时但开销爆炸（mock test 和 fragment 一对多，可能跑几十次 cjpm test）。
(b) 每个 fragment 翻译完，只跑 focal method 命中此 fragment 的那部分 \_test.cj —— 需要从 .workflow.json 抽 focal 信息建索引，按 class.method 过滤。
(c) 只在 is_test_method=True 的 fragment（即整段测试翻完）那一步跑 —— 接近现状但仍是子集。
(d) 整个 project 翻译完后一次性跑全量 —— 等价于现在手工执行 run.sh，并不算"按 fragment 自动触发"。
→ 你说的"按 fragment 自动触发"具体指 (a) / (b) / (c) 中的哪个？我倾向 (b)，但 focal mapping 还没有现成代码。

3. mock.sh 的一次性预备工作放在哪里
   mock.sh 跑 mvn 枚举所有 @Test 方法、生成全部 \_test.cj 到 /tmp/cangjie_mock/<project>/，跑一次就要几分钟到几十分钟：

(a) 每次 translate_fragment.sh 启动时检查 staging 是否存在，缺了就调 mock.sh，存在就复用。
(b) 把 mock.sh 拆成"阶段 2.x"放进 start.md 主流程，做成独立的 bash scripts/java/build_mock_corpus.sh <project>，由用户在跑翻译之前显式执行。
(c) compositional_translation 完全不管，约定用户必须先手动跑过 mock.sh。
→ 选哪个？另外 staging 的失效条件是什么（Java 源动了？）？

4. mock.sh 的硬编码 TEST_CLASS
   start.md 已经说了硬编码 com.example.minimal.AppTest。整合时是否就地修复成自动枚举 src/test/java/\**/*Test.java？还是继续接受单 TEST_CLASS 参数？我倾向自动枚举（方法已经在内层枚举了，只差类）。

5. runtime.sh inject 的生命周期
   helper.cj + simple_ioc.cj 必须在 cjpm test 前已注入。整合后：

(a) 进入 translate() 第一个 fragment 之前自动 inject，整个翻译会话结束（含异常）后 clean。
(b) 每个 fragment 跑测试前 inject、跑完 clean —— 太频繁，没必要。
(c) 仍由用户手动 runtime.sh inject 提前做好。
→ 推荐 (a)，确认？另外 helper.cj/simple_ioc.cj 注入到的目录受问题 1 的答案影响。

6. change_mode 与翻译写文件的并发
   change_mode.py apply 会就地把 cangjie 源里的 private/protected 字段、零参 init 改成 public，并埋 // CHANGE_MODE: 桩注释；restore 时按桩反向。问题：

翻译 pipeline 在编译 fragment 时也在持续往同一份源码追加/替换内容；如果 change_mode 已经 apply，新写入的代码不会被 apply（漏改字段）；如果每个 fragment 跑测试前临时 apply / 跑完 restore，restore 又要保证把上一次 apply 期间新增的 private 字段也覆盖到——这是双向风险。
→ 想清楚的方案是什么：

(i) 每个 fragment 测试前 apply、测试后 restore（每次 apply 重新扫描全部源码，restore 时按当前桩注释还原）。
(ii) 整个翻译会话开始时 apply 一次，结束 restore 一次；翻译期间新写入的代码我们另行注入"public 化"逻辑（成本最高）。
(iii) 要求骨架在生成阶段就直接是 public（彻底绕开 change_mode）。
我倾向 (i)，但需要确认 change_mode.py apply 在已经 apply 过的源上重复 apply 是幂等的（可能要先 grep 验证）。

7. 失败语义和反馈循环
   mock 测试失败时怎么办：

(a) 仅记 test_execution: {outcome: failure, message: ...} 到 schema，不影响翻译流向。
(b) 触发递归重译（类似编译失败），把 cjpm test 的 stderr 注入下一轮 prompt 作为 feedback；如果 fragment 是非 test-method，等于把 mock-test 失败当编译错误对待。
(c) (b) + 通过 RAG 检索测试错误相关文档。
→ 哪种？对应预算多少（编译预算现在是 5/2/2）？

8. 测试结果如何写入 schema
   现在 test_execution 字段被写成 pending / not-exercised / success / dict。mock 测试一个 fragment 可能有多个相关 \_test.cj，要存：

(a) 聚合 {"pass": N, "fail": M, "failed_tests": [...]}。
(b) 每个测试单独条目，map 形式：{"<test_name>": {outcome, message}}。
(c) 仅成功/失败 + 末次输出。
→ 哪个？

9. 整合形态
   选项 A：保留 shell 脚本，在 compositional_translation_validation.py 里 subprocess.run(["bash", "run.sh", ...]) 外壳调用。改动最小，但日志/错误处理割裂。
   选项 B：把 run.sh 内核（change_mode → instrument → cjpm test → deinstrument 循环）端口到 Python 模块（如 src/java/isolation_validation/test_runner.py），主流程直接 import。mock.sh 仍保留为一次性预备脚本。
   选项 C：全部移到 Python，shell 脚本删除。
   → 我推荐 B（核心循环 Python 化便于错误传播给 LLM，预备阶段脚本仍可手动跑）。同意？

10. shell 脚本去留
    整合完成后，mock.sh / run.sh / log_tests.sh / instrument.sh / runtime.sh 是否：

(a) 全部删除。
(b) 保留作为调试工具（更新文档说明不再是临时方案，是 debug 工具）。
(c) 仅保留 instrument.sh（单步调试用）。11. start.md 文档怎么改
整合完成后，start.md 当前的 "Mock 测试验证（手动流程，临时）" 章节是：

(a) 整段删除，仅在 §2.5 里加一小节"自动 mock 测试验证"。
(b) 改名为"调试用：手动复现 mock 测试"，作为故障排查手段保留。12. CLI 接口
translate_fragment.sh 现在的参数是 <project> <model> <temperature>。整合 mock 测试后，是否：

加 --enable_mock_test（默认 false，先小步推进）？
还是默认开启，加 --no_mock_test 来跳过？
mock 测试失败时是否影响 fragment 整体 status？
这些问题里 1、2、5、6、9 是必须先拍板的（影响整体架构），其他可以先按你的偏好默认值往下走。请逐条回我（或直接说"按你建议"我也会按倾向选）。

1.A 2. 每个fragment翻译完先编译，编译通过后开始mock测试，跑focal method即为待测试method的测试 3. b 4. 自动枚举 5. b 6. (i) 7. (b) 8. (c) 9. B 10. 先放着不用管 11. 默认开启，--no_mock_test控制跳过

收到。在动手前还有一批衍生疑问需要确认（你的答案带出了一些隐含问题）：

A. 关于 #5 的复核（怀疑笔误）
我列的选项是：

(a) 整个翻译会话开始 inject，结束 clean
(b) 每个 fragment 跑测试前 inject、跑完 clean（我自己标注"太频繁、没必要"）
(c) 用户手动 runtime.sh inject
你回 (b)，但 helper.cj/simple_ioc.cj 是固定内容（仅按包名渲染一次就够），每个 fragment 都重写文件没收益，反而每次都触发增量编译重新热到这两个文件。确认你确实要 (b) 吗？还是想选 (a)？

B. 关于 #1（mock 跑 skeletons 目录）
skeletons 目录目前只有 src/：

data/java/skeletons/<project>/cjpm.toml 存在吗？还是要新增？我没在 create_skeleton.py 里看到生成 cjpm.toml 的逻辑。
如果需要新增：包名怎么定？沿用 projects/cangjie/original_projects/<project>/cjpm.toml 的 name 字段？还是固定为 <project>？
cjpm test 必须能跑通（依赖、target 配置等），目前 skeletons 是否具备？需要我先在 minimal 上手验证一次吗？
C. 关于 #2（focal method 匹配的精度）
mock pipeline 产物：每个 \_test.cj 配一个 .workflow.json。workflow 里记录了 focal class+method（Java 侧 FQCN，例如 com.example.minimal.App.foo）。

主流程 fragment 携带：

schema_name（文件级，如 App）
class_name（TRAM 格式 15-30:App，冒号后是 simple name）
fragment_name（带签名形式，如 25-28:foo）
匹配方案要哪种？

(i) 按 simple_class.simple_method_name（忽略签名重载）—— 简单粗暴，重载会导致一对多。
(ii) 按 simple_class.method_name + 参数 arity —— 精度更好，但要从 workflow 拿到参数 arity。
(iii) 按完整签名匹配 —— 最严格，但 workflow 是否携带完整签名我得现场确认。
我倾向先 (i)，重载冲突时把所有命中的 \_test.cj 都跑一遍。可以吗？

D. 关于 #2 衍生：什么算"翻译完"
每个 fragment 现在的"翻译完"状态：

(1) field / static_initializer：编译通过后 break，不进 test 阶段。
(2) test method (is_test_method=True)：编译通过直接 return，不进 test 阶段。
(3) 普通 method：编译通过后进入 TEST EXECUTION 块（当前是占位），然后 break。
mock 测试只对 (3) 跑？还是 (1)(2) 也跑（比如 field 翻完会改变状态，可能需要回归测试）？我倾向只对 (3) 跑，确认？

E. 关于 #7（mock 失败递归重译）
重译的预算给多少？（编译失败给 5，syntactic 给 2）。我倾向 mock 失败给 2（mock 错误往往是逻辑错，多次重试边际收益低）。同意？

cjpm test 失败输出可能上千行，注入 prompt 时如何截断？

(i) 取末尾 N 行（默认 50）。
(ii) 提取 expected: ... actual: ... 这类断言关键行。
(iii) 全量原样塞进去，靠模型自己截。
我倾向 (i)。同意？

mock 失败时是否同时调用 RAG inject_error_context（像编译失败那样）？我倾向不调，因为 mock 失败是逻辑错而非语法/API 错，CangjieCorpus 命中价值低。同意？

F. 关于 #3（拆出 build_mock_corpus.sh）
路径定为 scripts/java/build_mock_corpus.sh，参数 <project>。是否还需要 <model> / <temperature> 这种？我看 mock.sh 里没用到，所以只 <project> 一个参数。确认？
翻译启动时如果 staging 不存在 → 报错并提示用户先跑 build_mock_corpus.sh（不自动调用，因为耗时长）。同意？
staging 失效检测：不做，由用户负责（Java 源动了就手动重跑）。同意？
G. 关于 #6（change_mode 幂等）
change_mode.py apply 在已经 apply 过的源上重复运行，行为如何？我得先 grep 确认。如果不幂等，实施 (i) 就要先 restore 再 apply，或者引入"已 apply"标记文件。允许我在动手前先做一次小验证（读 change_mode.py + 在 minimal 上空跑测试），再回来给你最终方案吗？

H. 关于 #11 + CLI
旗标名定为 --no_mock_test（默认 mock 开启）。translate_fragment.sh 透传该参数。同意？

mock 失败但仍按 (b) 重译耗尽预算后，fragment 的最终 translation_status 是？

(i) attempted（保持当前编译失败的语义，不是 completed）—— 这等于把 mock 失败当编译失败。
(ii) completed（编译通过就算翻译完成），仅 test_execution 字段记 failure。
按 (b) 的字面意思应该是 (i)，但 (ii) 更符合"编译已通过"的现状。你想要哪个？

A、B、C、E、G、H 必须确认；D、F 是提倡选项的复核，没异议就按我倾向走。回我后我开始动手。
