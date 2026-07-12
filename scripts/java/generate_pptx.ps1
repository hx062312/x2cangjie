# Generate a .pptx file with correct ZIP path separators (forward slash).
# Fixes "file corrupted" caused by CreateFromDirectory using backslashes.
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$tmpDir = Join-Path $env:TEMP "pptx_fix_$(Get-Random)"
$outPath = (Resolve-Path ".").Path + "\docs\presentation.pptx"

$dirs = @("$tmpDir","$tmpDir\_rels","$tmpDir\ppt","$tmpDir\ppt\_rels","$tmpDir\ppt\theme","$tmpDir\ppt\slideMasters","$tmpDir\ppt\slideMasters\_rels","$tmpDir\ppt\slideLayouts","$tmpDir\ppt\slideLayouts\_rels","$tmpDir\ppt\slides","$tmpDir\ppt\slides\_rels")
foreach ($d in $dirs) { New-Item -ItemType Directory -Path $d -Force | Out-Null }

function W($path,$content){ [System.IO.File]::WriteAllText($path,$content,[System.Text.UTF8Encoding]::new($false)) }
function Esc($s){ return ($s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;') }

$slideW=12192000;$slideH=6858000

# [Content_Types].xml
$ct='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/><Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/><Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/><Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>'
for($i=1;$i -le 11;$i++){$ct+="<Override PartName=""/ppt/slides/slide$i.xml"" ContentType=""application/vnd.openxmlformats-officedocument.presentationml.slide+xml""/>"}
$ct+='</Types>'
W "$tmpDir\[Content_Types].xml" $ct

W "$tmpDir\_rels\.rels" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/></Relationships>'

W "$tmpDir\ppt\theme\theme1.xml" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Dark"><a:clrScheme name="Dark"><a:dk1><a:srgbClr val="0D1B2A"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="1B2A3A"/></a:dk2><a:lt2><a:srgbClr val="D0D0D0"/></a:lt2><a:accent1><a:srgbClr val="00BEE6"/></a:accent1><a:accent2><a:srgbClr val="4EC9B0"/></a:accent2><a:accent3><a:srgbClr val="FFA500"/></a:accent3><a:accent4><a:srgbClr val="FF5555"/></a:accent4><a:accent5><a:srgbClr val="569CD6"/></a:accent5><a:accent6><a:srgbClr val="C586C0"/></a:accent6><a:hlink><a:srgbClr val="00BEE6"/></a:hlink><a:folHlink><a:srgbClr val="00BEE6"/></a:folHlink></a:clrScheme><a:fontScheme name="Dark"><a:majorFont typeface="Calibri"/><a:minorFont typeface="Calibri"/></a:fontScheme><a:fmtScheme name="Default"><a:fillLst><a:solidFill><a:srgbClr val="0D1B2A"/></a:solidFill></a:fillLst><a:lnLst><a:ln w="9525" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:srgbClr val="00BEE6"/></a:solidFill><a:prstDash val="solid"/></a:ln></a:lnLst><a:effectLst/><a:bgFillLst><a:solidFill><a:srgbClr val="0D1B2A"/></a:solidFill></a:bgFillLst></a:fmtScheme></a:theme>'

W "$tmpDir\ppt\slideMasters\slideMaster1.xml" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:bg><p:bgRef idx="1001"><a:srgbClr val="0D1B2A"/></p:bgRef></p:bg><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name="Group 1"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/><p:sldLayoutIdLst><p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst><p:txStyles><p:titleStyle><a:lvl1pPr algn="l"><a:defRPr sz="2800" b="1"><a:solidFill><a:srgbClr val="00BEE6"/></a:solidFill></a:defRPr></a:lvl1pPr></p:titleStyle><p:bodyStyle><a:lvl1pPr><a:defRPr sz="1600"><a:solidFill><a:srgbClr val="D0D0D0"/></a:solidFill></a:defRPr></a:lvl1pPr></p:bodyStyle><p:otherStyle/></p:txStyles></p:sldMaster>'

W "$tmpDir\ppt\slideMasters\_rels\slideMaster1.xml.rels" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/></Relationships>'

W "$tmpDir\ppt\slideLayouts\slideLayout1.xml" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name="Group 1"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld></p:sldLayout>'

W "$tmpDir\ppt\slideLayouts\_rels\slideLayout1.xml.rels" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/></Relationships>'

# presentation.xml
$pres='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" saveSubsetFonts="1"><p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst><p:sldIdLst>'
for($i=1;$i -le 11;$i++){$pres+="<p:sldId id=""$(256+$i)"" r:id=""rId$($i+1)""/>"}
$pres+="</p:sldIdLst><p:sldSz cx=`"$slideW`" cy=`"$slideH`" type=`"screen16x9`"/><p:notesSz cx=`"6858000`" cy=`"9144000`"/></p:presentation>"
W "$tmpDir\ppt\presentation.xml" $pres

$pr='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>'
for($i=1;$i -le 11;$i++){$pr+="<Relationship Id=""rId$($i+1)"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide"" Target=""slides/slide$i.xml""/>"}
$pr+='</Relationships>'
W "$tmpDir\ppt\_rels\presentation.xml.rels" $pr

# Slide builder
function New-SlideXml($title,$sps){
$x='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name="G"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>'
$x+="<p:sp><p:nvSpPr><p:cNvPr id=`"10`" name=`"BG`"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"0`" y=`"0`"/><a:ext cx=`"$slideW`" cy=`"$slideH`"/></a:xfrm><a:prstGeom prst=`"rect`"><a:avLst/></a:prstGeom><a:solidFill><a:srgbClr val=`"0D1B2A`"/></a:solidFill></p:spPr><p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody></p:sp>"
if($title){$x+="<p:sp><p:nvSpPr><p:cNvPr id=`"11`" name=`"T`"/><p:cNvSpPr txBox=`"1`"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"457200`" y=`"274000`"/><a:ext cx=`"11277600`" cy=`"571500`"/></a:xfrm><a:prstGeom prst=`"rect`"><a:avLst/></a:prstGeom><a:noFill/></p:spPr><p:txBody><a:bodyPr wrap=`"square`" lIns=`"0`" tIns=`"0`" rIns=`"0`" bIns=`"0`"/><a:lstStyle/><a:p><a:r><a:rPr lang=`"en-US`" sz=`"2400`" b=`"1`"><a:solidFill><a:srgbClr val=`"00BEE6`"/></a:solidFill></a:rPr><a:t>$(Esc $title)</a:t></a:r></a:p></p:txBody></p:sp>"}
foreach($sp in $sps){$x+=$sp}
$x+='</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>'
return $x}

function New-TB($id,$nm,$x,$y,$w,$h,$ps){
$xm="<p:sp><p:nvSpPr><p:cNvPr id=`"$id`" name=`"$nm`"/><p:cNvSpPr txBox=`"1`"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"$x`" y=`"$y`"/><a:ext cx=`"$w`" cy=`"$h`"/></a:xfrm><a:prstGeom prst=`"rect`"><a:avLst/></a:prstGeom><a:noFill/></p:spPr><p:txBody><a:bodyPr wrap=`"square`" lIns=`"91440`" tIns=`"45720`" rIns=`"91440`" bIns=`"45720`"/><a:lstStyle/>"
foreach($p in $ps){$sz=if($p.size){$p.size*100}else{1400};$b=if($p.bold){' b="1"'}else{''};$c=if($p.color){$p.color}else{'D0D0D0'};$xm+="<a:p><a:r><a:rPr lang=`"en-US`" sz=`"$sz`"$b><a:solidFill><a:srgbClr val=`"$c`"/></a:solidFill></a:rPr><a:t>$(Esc $p.text)</a:t></a:r></a:p>"}
$xm+='</p:txBody></p:sp>'
return $xm}

# Slide 1 - Cover
W "$tmpDir\ppt\slides\slide1.xml" (New-SlideXml "" @(
(New-TB 20 "T" 914400 2744000 10363200 914400 @(@{text="Fragment 翻译增强";size=36;color="FFFFFF";bold=$true}))
(New-TB 21 "S" 914400 3657600 10363200 457200 @(@{text="原理、实现与消融分析";size=22;color="00BEE6";bold=$false}))
(New-TB 22 "I" 914400 4800000 10363200 914400 @(@{text="基于伪代码中间层、语法注入与结构检索的 LLM 代码翻译改进";size=14;color="D0D0D0";bold=$false},@{text="项目：x2cangjie  |  Java - 仓颉(Cangjie)自动翻译  |  2026-07-08";size=12;color="D0D0D0";bold=$false}))
))

# Slide 2 - Background
W "$tmpDir\ppt\slides\slide2.xml" (New-SlideXml "背景：x2cangjie 在做什么" @(
(New-TB 20 "D" 457200 823000 11277600 914400 @(@{text="目标：把 Java 库自动翻译成仓颉(Cangjie)语言";size=18;color="FFFFFF";bold=$true},@{text="Pipeline: preprocess - create_schema - get_dependencies - translate_types - create_skeleton - build_mock_corpus - translate_fragment - analyze_errors";size=10;color="D0D0D0";bold=$false},@{text="核心是第 7 步 translate_fragment：LLM 逐个 fragment 翻译，每填一个跑 cjpm build 编译验证，失败带错误反馈重试";size=12;color="D0D0D0";bold=$false}))
(New-TB 21 "E" 457200 2286000 11277600 457200 @(@{text="观察到的两类系统性错误：";size=16;color="00BEE6";bold=$true}))
(New-TB 22 "A" 457200 2743000 5486400 2743000 @(@{text="A: 错误继承 Java 源语法/API";size=14;color="FFA500";bold=$true},@{text="LLM 照搬 stream API / checked exception / for-each lambda";size=12;color="D0D0D0";bold=$false},@{text="根因：LLM 模仿源码结构而非理解意图后用目标语言惯用法重写";size=12;color="D0D0D0";bold=$false}))
(New-TB 23 "B" 6400800 2743000 5334000 2743000 @(@{text="B: 使用错误的 Cangjie 语法/API";size=14;color="FF5555";bold=$true},@{text="泛型用 extends 而非 where T<:Bound、Any 当 HashMap key、boolean 而非 Bool";size=12;color="D0D0D0";bold=$false},@{text="根因：Cangjie 是新语言，LLM 训练数据中几乎没有 Cangjie 代码";size=12;color="D0D0D0";bold=$false}))
(New-TB 24 "M" 457200 5486000 11277600 457200 @(@{text="针对 A/B 两类错误，做了三件事(Part 1/2/3)，互相独立、可单独或组合开关";size=16;color="4EC9B0";bold=$true}))
))

# Slide 3 - Part 1
W "$tmpDir\ppt\slides\slide3.xml" (New-SlideXml "Part 1：伪代码中间层(解决错误 A)" @(
(New-TB 20 "P" 457200 823000 11277600 1371000 @(@{text="参考论文：";size=14;color="00BEE6";bold=$true},@{text="A1: Pseudocode-based Code Translation (arXiv 2510.00920, 2025) - 源-伪代码-目标，两阶段语义翻译";size=12;color="D0D0D0";bold=$false},@{text="A3: NL in the Middle (CASCON 2025) - 自然语言中间表示效果最好(+13.8%)";size=12;color="D0D0D0";bold=$false},@{text="A6: Assessing Intermediate Languages (arXiv 2407.05411) - 警示：收益可能部分来自 CoT 多步推理效应";size=12;color="D0D0D0";bold=$false}))
(New-TB 21 "R" 457200 2743000 11277600 1371000 @(@{text="论文原理(A1)：";size=14;color="00BEE6";bold=$true},@{text="直接翻译时 LLM 试图模仿源码结构 - 生成语义不一致的代码";size=12;color="D0D0D0";bold=$false},@{text="伪代码中间层：LLM 先把源码抽象成语言无关伪代码，再从伪代码生成目标代码";size=12;color="D0D0D0";bold=$false},@{text="测试 5 种策略组合，发现'伪代码+源代码'组合效果最好 - 伪代码居中解决歧义，源码作为 fallback";size=12;color="4EC9B0";bold=$true}))
(New-TB 22 "I" 457200 4572000 11277600 1828000 @(@{text="项目实现：";size=14;color="00BEE6";bold=$true},@{text="Java fragment - LLM - 伪代码+注释 (Phase-1) - 伪代码+Java源码+metadata - LLM - Cangjie (Phase-2)";size=12;color="D0D0D0";bold=$false},@{text="Phase-1 prompt 规约：仅通用关键字、API 调用改写为动词短语、每块前 // 注释说明意图";size=12;color="D0D0D0";bold=$false},@{text="失败退化为直接翻译；_skip_prompt_build 优化跳过昂贵上下文加载";size=12;color="D0D0D0";bold=$false}))
))

# Slide 4 - Part 2
W "$tmpDir\ppt\slides\slide4.xml" (New-SlideXml "Part 2：Cangjie 语法 EBNF 注入(解决错误 B)" @(
(New-TB 20 "P" 457200 823000 11277600 1000000 @(@{text="参考论文：";size=14;color="00BEE6";bold=$true},@{text="B2: Grammar Prompting (Wang et al., ACL 2023) - BNF 语法注入 prompt，仅注入不需约束解码就显著提升";size=12;color="D0D0D0";bold=$false},@{text="B1: DocCGen (EMNLP 2024) - 从文档提取 grammar/schema 做约束解码，OOD 场景效果显著";size=12;color="D0D0D0";bold=$false}))
(New-TB 21 "K" 457200 2286000 11277600 457200 @(@{text="Cangjie 对 LLM 就是 DSL - 训练数据极少";size=16;color="FFA500";bold=$true}))
(New-TB 22 "C" 457200 2830000 11277600 2743000 @(@{text="项目实现 - 注入 8 条硬约束(G1-G8)：";size=14;color="00BEE6";bold=$true},@{text="G1: 泛型用 where T <: Bound(不是 extends)  - Java ? extends T";size=12;color="D0D0D0";bold=$false},@{text="G3: Any 不满足 Hashable，用 AnyHashable      - HashMap<Object,V> 编译报错";size=12;color="D0D0D0";bold=$false},@{text="G5: 布尔类型是 Bool(不是 boolean)           - Java boolean";size=12;color="D0D0D0";bold=$false},@{text="G6: 字符串插值 模板表达式              - Java String.format";size=12;color="D0D0D0";bold=$false},@{text="第二部分：运行时 API 映射表(Object-AnyHashable, Runnable-()-Unit 等)";size=12;color="D0D0D0";bold=$false},@{text="设计：规则在 YAML 配置可编辑；单例缓存；靠编译错误反馈做 rejection sampling";size=12;color="D0D0D0";bold=$false}))
))

# Slide 5 - Part 3
W "$tmpDir\ppt\slides\slide5.xml" (New-SlideXml "Part 3：语法图 RAG(CFG/DFG 结构相似检索)" @(
(New-TB 20 "P" 457200 823000 11277600 1000000 @(@{text="参考论文：";size=14;color="00BEE6";bold=$true},@{text="B3: CodeGRAG (Huang et al., arXiv 2405.02355, 2024) - 提取 CFG+DFG 融合图，GNN+跨语言检索结构相似代码";size=12;color="D0D0D0";bold=$false},@{text="B4: Syntax-Aware RAG (EMNLP 2023 Findings) - 在 RAG 中引入语法感知，不只用语义相似还用语法结构相似度";size=12;color="D0D0D0";bold=$false}))
(New-TB 21 "I" 457200 2286000 11277600 914400 @(@{text="项目实现(实用化简化) - 纯正则结构指纹 + Jaccard 相似度，无 NN/CUDA/额外依赖";size=14;color="00BEE6";bold=$true}))
(New-TB 22 "D" 457200 3200000 11277600 1828000 @(@{text="结构指纹三维度：";size=14;color="00BEE6";bold=$true},@{text="shape_bag      : 12 个操作类别计数(cf_if/cf_loop/op_call/op_index 等)，桶化为 0-3";size=12;color="D0D0D0";bold=$false},@{text="call_names     : 方法调用点标识符集合";size=12;color="D0D0D0";bold=$false},@{text="container_types: 命中集合类型名(list/array/map/set 等)";size=12;color="D0D0D0";bold=$false},@{text="检索：加权 Jaccard = 0.6*shape + 0.25*call + 0.15*container，返回 top-3";size=12;color="FFFFFF";bold=$false},@{text="索引：扫描 CangjieCorpus，12874 个代码块，pickle 序列化";size=12;color="D0D0D0";bold=$false},@{text="与现有 RAG 互补：原 RAG 回答'该用什么 API'，Part 3 回答'该写什么样的代码骨架'";size=12;color="4EC9B0";bold=$true}))
))

# Slide 6 - Combination
W "$tmpDir\ppt\slides\slide6.xml" (New-SlideXml "三部分如何组合工作" @(
(New-TB 20 "O" 457200 823000 11277600 1000000 @(@{text="Prompt 注入顺序：";size=14;color="00BEE6";bold=$true},@{text="persona - instruction - grammar(Part2) - Java source - pseudocode(Part1) - partial - generics - KB - RAG docs - syntax_graph(Part3) - ICL - feedback";size=10;color="D0D0D0";bold=$false}))
(New-TB 21 "F" 457200 2286000 11277600 457200 @(@{text="CLI 开关(三个 flag 默认 false，向后兼容)：";size=14;color="00BEE6";bold=$true}))
(New-TB 22 "T" 457200 2743000 11277600 2743000 @(@{text="仅修 Java-Cangjie API 模式继承错     pseudo=true  grammar=false  syntax=false";size=12;color="D0D0D0";bold=$false},@{text="不熟悉 Cangjie 语法(多为编译报语法错) pseudo=false grammar=true   syntax=false";size=12;color="D0D0D0";bold=$false},@{text="需要 few-shot 结构模板              pseudo=false grammar=false  syntax=true";size=12;color="D0D0D0";bold=$false},@{text="全开(增益最高)                      pseudo=true  grammar=true   syntax=true";size=12;color="4EC9B0";bold=$true},@{text="设计逻辑：grammar 在最前(先读规则再读代码)；伪代码在源码后(理解意图后再翻译)";size=12;color="D0D0D0";bold=$false},@{text="结构示例在 RAG 文档后、ICL 前(作为'怎么写'的模板参考)";size=12;color="D0D0D0";bold=$false}))
))

# Slide 7 - Code structure
W "$tmpDir\ppt\slides\slide7.xml" (New-SlideXml "代码结构" @(
(New-TB 20 "N" 457200 823000 5486400 3200000 @(@{text="新增文件：";size=14;color="4EC9B0";bold=$true},@{text="grammar_prompt.py (Part 2)";size=12;color="D0D0D0";bold=$false},@{text="syntax_graph.py (Part 3)";size=12;color="D0D0D0";bold=$false},@{text="ablation_compare.py (消融分析)";size=12;color="D0D0D0";bold=$false},@{text="build_syntax_graph_index.sh";size=12;color="D0D0D0";bold=$false},@{text="run_ablation.sh";size=12;color="D0D0D0";bold=$false},@{text="test_grammar_prompt.py";size=12;color="D0D0D0";bold=$false},@{text="test_syntax_graph.py";size=12;color="D0D0D0";bold=$false},@{text="test_ablation_compare.py";size=12;color="D0D0D0";bold=$false}))
(New-TB 21 "M" 6400800 823000 5334000 3200000 @(@{text="修改文件：";size=14;color="FFA500";bold=$true},@{text="compositional_translation_validation.py";size=12;color="D0D0D0";bold=$false},@{text="prompt_generator.py (Part 1/2/3 注入点)";size=12;color="D0D0D0";bold=$false},@{text="prompt_templates.yaml (新模板)";size=12;color="D0D0D0";bold=$false},@{text="translate_fragment.sh (3 个新参数)";size=12;color="D0D0D0";bold=$false},@{text="create_skeleton.py (类型映射修复)";size=12;color="D0D0D0";bold=$false},@{text="interface_shim.py (overload 去重)";size=12;color="D0D0D0";bold=$false},@{text="type_expression.py (URL 误判修复)";size=12;color="D0D0D0";bold=$false}))
(New-TB 22 "E" 457200 4114000 11277600 2286000 @(@{text="关键代码入口：";size=14;color="00BEE6";bold=$true},@{text="翻译主循环           - compositional_translation_validation.py - translate()";size=12;color="D0D0D0";bold=$false},@{text="prompt 组装          - prompt_generator.py - build_base_prompt()";size=12;color="D0D0D0";bold=$false},@{text="Part 1 伪代码生成    - compositional_translation_validation.py - _generate_pseudocode()";size=12;color="D0D0D0";bold=$false},@{text="Part 2 语法规则      - configs/prompt_templates.yaml - cangjie_grammar_context";size=12;color="D0D0D0";bold=$false},@{text="Part 3 结构指纹      - syntax_graph.py - infer_structural_signature()";size=12;color="D0D0D0";bold=$false},@{text="消融报告生成         - ablation_compare.py - main()";size=12;color="D0D0D0";bold=$false}))
))

# Slide 8 - Ablation design
W "$tmpDir\ppt\slides\slide8.xml" (New-SlideXml "消融实验设计" @(
(New-TB 20 "M" 457200 823000 11277600 1000000 @(@{text="动机(A6 论文警示)：伪代码中间层的收益可能部分来自 CoT 多步推理效应，需要 ablation 分离每部分的增量来源";size=14;color="D0D0D0";bold=$false}))
(New-TB 21 "T" 457200 2286000 11277600 3200000 @(@{text="8 种 run-tag(2^3 = 8)：";size=14;color="00BEE6";bold=$true},@{text="baseline         pseudo=false  grammar=false  syntax=false";size=12;color="D0D0D0";bold=$false},@{text="pseudo           pseudo=true   grammar=false  syntax=false";size=12;color="D0D0D0";bold=$false},@{text="grammar          pseudo=false  grammar=true   syntax=false";size=12;color="D0D0D0";bold=$false},@{text="syntax           pseudo=false  grammar=false  syntax=true";size=12;color="D0D0D0";bold=$false},@{text="pseudo+grammar   pseudo=true   grammar=true   syntax=false";size=12;color="D0D0D0";bold=$false},@{text="pseudo+syntax    pseudo=true   grammar=false  syntax=true";size=12;color="D0D0D0";bold=$false},@{text="grammar+syntax   pseudo=false  grammar=true   syntax=true";size=12;color="D0D0D0";bold=$false},@{text="all              pseudo=true   grammar=true   syntax=true";size=12;color="4EC9B0";bold=$true}))
(New-TB 22 "C" 457200 5486000 11277600 914400 @(@{text="配置：commons-csv / 381 fragments / gpt-4o / 温度 0.0 / 每组前重建 skeleton / Fisher exact 双侧 p 值";size=12;color="D0D0D0";bold=$false}))
))

# Slide 9 - Ablation results
W "$tmpDir\ppt\slides\slide9.xml" (New-SlideXml "消融结果" @(
(New-TB 20 "T" 457200 823000 11277600 4114000 @(@{text="8 组总览(commons-csv / gpt-4o / 381 fragments)：";size=14;color="00BEE6";bold=$true},@{text="";size=4;color="0D1B2A";bold=$false},@{text="baseline              241 完成    63.3%     --";size=14;color="D0D0D0";bold=$false},@{text="pseudo (Part 1)        249 完成    65.4%     +2.1pp";size=14;color="D0D0D0";bold=$false},@{text="grammar (Part 2)       255 完成    66.9%     +3.7pp";size=14;color="D0D0D0";bold=$false},@{text="syntax (Part 3)        258 完成    67.7%     +4.5pp";size=14;color="4EC9B0";bold=$true},@{text="pseudo+grammar (1+2)   259 完成    68.0%     +4.7pp";size=14;color="D0D0D0";bold=$false},@{text="pseudo+syntax (1+3)    260 完成    68.2%     +5.0pp";size=14;color="D0D0D0";bold=$false},@{text="grammar+syntax (2+3)   260 完成    68.2%     +5.0pp";size=14;color="D0D0D0";bold=$false},@{text="all (1+2+3)            260 完成    68.2%     +5.0pp";size=14;color="4EC9B0";bold=$true}))
(New-TB 21 "F" 457200 5029000 11277600 1371000 @(@{text="单部分独立效应排序：Part 3 (+4.5pp) > Part 2 (+3.7pp) > Part 1 (+2.1pp)";size=14;color="4EC9B0";bold=$true},@{text="组合饱和：两两组合接近 +5.0pp，三部分全开无额外增益 - 覆盖的错误类型有重叠";size=14;color="FFA500";bold=$true},@{text="显著性：Fisher exact p 值均 >0.05(单项目 381 样本量不足)，但趋势清晰一致";size=12;color="D0D0D0";bold=$false}))
))

# Slide 10 - Analysis
W "$tmpDir\ppt\slides\slide10.xml" (New-SlideXml "结果分析与未来工作" @(
(New-TB 20 "F" 457200 823000 11277600 3200000 @(@{text="关键发现：";size=16;color="00BEE6";bold=$true},@{text="1. Part 3 语法图 RAG 单独贡献最大(+4.5pp) - 结构相似的 Cangjie 代码片段是最有效的 few-shot 示例";size=13;color="D0D0D0";bold=$false},@{text="2. Part 2 语法注入次之(+3.7pp) - EBNF 规则直接减少语法类编译错误";size=13;color="D0D0D0";bold=$false},@{text="3. Part 1 伪代码贡献最小(+2.1pp) - CoT 效应被 Part 2/3 部分吸收";size=13;color="D0D0D0";bold=$false},@{text="4. 组合饱和：Part 2+3 或 1+2+3 都达到 +5.0pp，覆盖错误类型有重叠";size=13;color="D0D0D0";bold=$false},@{text="5. 代价：Part 1 增加每 fragment 耗时 ~30%(多一次 LLM 调用)，Part 2/3 几乎无额外开销";size=13;color="D0D0D0";bold=$false}))
(New-TB 21 "U" 457200 4114000 11277600 2286000 @(@{text="后续可改进：";size=16;color="00BEE6";bold=$true},@{text="扩展到多项目多模型(jansi / commons-cli + deepseek-chat / glm-5.1)，增大样本量";size=13;color="D0D0D0";bold=$false},@{text="跑 mock 测试拿 test_pass 指标";size=13;color="D0D0D0";bold=$false},@{text="Part 1 做 CoT-only ablation 分离 CoT 效应";size=13;color="D0D0D0";bold=$false},@{text="Part 3 升级为 tree-sitter 真实 CFG/DFG + 跨语言预训练模型";size=13;color="D0D0D0";bold=$false}))
))

# Slide 11 - References
W "$tmpDir\ppt\slides\slide11.xml" (New-SlideXml "参考论文速查" @(
(New-TB 20 "R" 457200 823000 11277600 4114000 @(@{text="A1  Pseudocode-based Code Translation (arXiv 2510.00920)          Part 1";size=13;color="D0D0D0";bold=$false},@{text="A3  NL in the Middle (CASCON 2025)                                Part 1 设计依据";size=13;color="D0D0D0";bold=$false},@{text="A6  Assessing Intermediate Languages (arXiv 2407.05411)          Part 1 ablation 依据";size=13;color="D0D0D0";bold=$false},@{text="B2  Grammar Prompting (ACL 2023)                                 Part 2";size=13;color="D0D0D0";bold=$false},@{text="B1  DocCGen (EMNLP 2024)                                         Part 2 补充";size=13;color="D0D0D0";bold=$false},@{text="B3  CodeGRAG (arXiv 2405.02355)                                  Part 3";size=13;color="D0D0D0";bold=$false},@{text="B4  Syntax-Aware RAG (EMNLP 2023 Findings)                       Part 3 补充";size=13;color="D0D0D0";bold=$false},@{text="";size=8;color="0D1B2A";bold=$false},@{text="完整论文摘要：docs/related_work_code_translation.md";size=12;color="00BEE6";bold=$false},@{text="完整实现细节：docs/fragment_translation_enhancements.md";size=12;color="00BEE6";bold=$false},@{text="完整工作汇报：docs/work_report.md";size=12;color="00BEE6";bold=$false}))
))

# Slide rels
for($i=1;$i -le 11;$i++){W "$tmpDir\ppt\slides\_rels\slide$i.xml.rels" '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/></Relationships>'}

# ============================================================================
# Build ZIP with FORWARD SLASH paths (the fix)
# ============================================================================
$docsDir=(Resolve-Path ".").Path+"\docs"
if(-not(Test-Path $docsDir)){New-Item -ItemType Directory -Path $docsDir -Force|Out-Null}
if(Test-Path $outPath){Remove-Item $outPath -Force}

$allFiles=Get-ChildItem $tmpDir -Recurse -File
$entries=@()
foreach($f in $allFiles){$rp=$f.FullName.Substring($tmpDir.Length+1)-replace '\\','/';$entries+=[PSCustomObject]@{File=$f.FullName;EntryName=$rp}}

$fs=[System.IO.File]::Create($outPath)
$zip=New-Object System.IO.Compression.ZipArchive($fs,[System.IO.Compression.ZipArchiveMode]::Create)
foreach($e in $entries){$ze=$zip.CreateEntry($e.EntryName,[System.IO.Compression.CompressionLevel]::Optimal);$es=$ze.Open();$data=[System.IO.File]::ReadAllBytes($e.File);$es.Write($data,0,$data.Length);$es.Close()}
$zip.Dispose();$fs.Close()
Remove-Item $tmpDir -Recurse -Force

# Verify
$v=[System.IO.Compression.ZipFile]::OpenRead($outPath)
$bad=$false;foreach($e in $v.Entries){if($e.FullName.Contains('\')){$bad=$true}};$v.Dispose()
$fi=Get-Item $outPath
Write-Output "Generated: $outPath"
Write-Output "Size: $([math]::Round($fi.Length/1KB,1)) KB"
Write-Output "Entries: $($entries.Count)  BackslashInPaths: $bad"
Write-Output "Slides: 11"
