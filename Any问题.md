# Any问题



1. 将 `AnyHashable.cj` 放入 `x2cangjie` 的资源目录，并在输出工程时自动复制到 `x2cangjie/runtime/` 下。

   **新建文件**：==`src/java/resources/x2cangjie/runtime/AnyHashable.cj`==





2. 在类型映射阶段，把 `HashMap` 键类型为 `Any` 的地方映射为 `AnyHashableWrapper`。

   

   ====

   对`create_skeleton.py`进行修改

   a. 首部添加 ——  在文件开头定义哈希容器集合（放在 `remove_duplicate_methods` 之前即可）

   ```
   # 需要键满足 Hashable + Equatable 的容器
   HASH_CONSTRAINED_CONTAINERS = {'HashMap', 'HashSet'}
   ```

   b.修改 `get_cangjie_type` 函数(83-117)（只改泛型分支部分）—— 替换泛型键 `Any` 为 `AnyHashable`

   ```
       # Handle generics like ArrayList<String>
       if '<' in java_type and java_type.endswith('>'):
           base_type = java_type[:java_type.index('<')]
           generic_part = java_type[java_type.index('<')+1:java_type.rindex('>')]
           # Handle nested generics by splitting on comma at depth 0
           generic_parts = []
           depth = 0
           current = ""
           for c in generic_part:
               if c == '<':
                   depth += 1
                   current += c
               elif c == '>':
                   depth -= 1
                   current += c
               elif c == ',' and depth == 0:
                   generic_parts.append(current.strip())
                   current = ""
               else:
                   current += c
           if current.strip():
               generic_parts.append(current.strip())
   
           generic_cangjie_list = [get_cangjie_type(g, type_map) for g in generic_parts]
   
           # Get base type translation
           if base_type in type_map:
               base_cangjie = type_map[base_type]
               # If base_cangjie already has generic params, replace them
               if '<' in base_cangjie:
                   base_cangjie = base_cangjie.split('<')[0]
           else:
               base_cangjie = base_type
   
           # 【新增】如果容器类型需要哈希约束，且键是 Any，则替换为 AnyHashable
           if base_cangjie in HASH_CONSTRAINED_CONTAINERS and generic_cangjie_list and generic_cangjie_list[0] == 'Any':
               generic_cangjie_list[0] = 'AnyHashable'
   
           generic_cangjie = ', '.join(generic_cangjie_list)
           return f"{base_cangjie}<{generic_cangjie}>"
   ```

   c. 在导入筛选部分插入 `import x2cangjie.runtime.*`

   **在 `if filtered_imports:` 这行之前加上**：(695)

   ```
       # 【新增】如果任何类型包含 AnyHashable，导入运行库
       if _uses_anyhashable(schema, class_order, type_map):
           filtered_imports.add('import x2cangjie.runtime.*')
   ```

   其中`_uses_anyhashable`函数,放在文件顶部

   ```
   def _uses_anyhashable(schema, class_order, type_map):
       """检查生成代码中是否使用了 AnyHashable 类型。"""
       for class_key in class_order:
           if class_key not in schema.get('classes', {}):
               continue
           class_info = schema['classes'][class_key]
           # 检查字段
           for field_key, field_info in class_info.get('fields', {}).items():
               for t in field_info.get('types', []):
                   ct = get_cangjie_type(t, type_map)
                   if 'AnyHashable' in ct:
                       return True
           # 检查方法参数和返回类型
           for method_key, method_info in class_info.get('methods', {}).items():
               for rt in method_info.get('return_types', []):
                   ct = get_cangjie_type(rt, type_map)
                   if 'AnyHashable' in ct:
                       return True
               for p in method_info.get('parameters', []):
                   ct = get_cangjie_type(p.get('type', 'Any'), type_map)
                   if 'AnyHashable' in ct:
                       return True
       return False
   ```

   d. 在输出前复制运行时 `AnyHashable.cj` —— 自动复制运行时文件

   在 `main` 函数中，刚创建 `skeletons_dir` 之后（`os.makedirs(skeletons_dir, exist_ok=True)` 下面）插入：(494)

   ```
       # 【新增】复制 AnyHashable 运行时文件到输出项目的 x2cangjie.runtime 包
       import shutil
       runtime_src = 'src/java/resources/x2cangjie/runtime/AnyHashable.cj'
       runtime_dst = os.path.join(skeletons_dir, 'src', 'x2cangjie', 'runtime')
       os.makedirs(runtime_dst, exist_ok=True)
       if os.path.exists(runtime_src):
           shutil.copy(runtime_src, os.path.join(runtime_dst, 'AnyHashable.cj'))
           # 同时复制到 translations 目录，以备后用
           trans_dst = os.path.join(translations_skeleton_dir, 'src', 'x2cangjie', 'runtime')
           os.makedirs(trans_dst, exist_ok=True)
           shutil.copy(runtime_src, os.path.join(trans_dst, 'AnyHashable.cj'))
       else:
           print(f"Warning: Runtime file not found at {runtime_src}")
   ```

   

3. 在代码生成阶段，对 `put`/`get` 的键参数包裹 `hashable(key)`，对取出的键调用 `.unwrap()`。

​	

4. 在每个生成文件的头部插入 `import x2cangjie.runtime.*`。(步骤2已经完成)









## 修改清单

### 1. `data/java/type_resolution/fixed_type_map.json` — 静态类型映射表

将所有哈希容器的 key/element 位置从 `Any` 改为 `AnyHashable`，共 17 处：

| 键                                       | 修改前                        | 修改后                                |
| :--------------------------------------- | :---------------------------- | :------------------------------------ |
| `java.util.Map`                          | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `java.util.HashMap`                      | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `java.util.LinkedHashMap`                | `LinkedHashMap<Any, Any>`     | `LinkedHashMap<AnyHashable, Any>`     |
| `java.util.TreeMap`                      | `TreeMap<Any, Any>`           | `TreeMap<AnyHashable, Any>`           |
| `java.util.HashSet`                      | `HashSet<Any>`                | `HashSet<AnyHashable>`                |
| `java.util.LinkedHashSet`                | `LinkedHashSet<Any>`          | `LinkedHashSet<AnyHashable>`          |
| `java.util.TreeSet`                      | `TreeSet<Any>`                | `TreeSet<AnyHashable>`                |
| `java.util.Hashtable`                    | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `java.util.concurrent.ConcurrentHashMap` | `ConcurrentHashMap<Any, Any>` | `ConcurrentHashMap<AnyHashable, Any>` |
| `java.util.Set`                          | `HashSet<Any>`                | `HashSet<AnyHashable>`                |
| `Map`                                    | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `HashMap`                                | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `LinkedHashMap`                          | `LinkedHashMap<Any, Any>`     | `LinkedHashMap<AnyHashable, Any>`     |
| `TreeMap`                                | `TreeMap<Any, Any>`           | `TreeMap<AnyHashable, Any>`           |
| `HashSet`                                | `HashSet<Any>`                | `HashSet<AnyHashable>`                |
| `LinkedHashSet`                          | `LinkedHashSet<Any>`          | `LinkedHashSet<AnyHashable>`          |
| `TreeSet`                                | `TreeSet<Any>`                | `TreeSet<AnyHashable>`                |
| `Hashtable`                              | `HashMap<Any, Any>`           | `HashMap<AnyHashable, Any>`           |
| `ConcurrentHashMap`                      | `ConcurrentHashMap<Any, Any>` | `ConcurrentHashMap<AnyHashable, Any>` |

### 2. `src/java/translation/create_skeleton.py` — 骨架生成

- **新增** `_HASH_KEY_CONTAINERS` 和 `_HASH_ELEMENT_CONTAINERS` 常量集合，标识需要 Hashable 约束的容器
- **修改** `get_cangjie_type()` 函数：在递归解析泛型参数后，检查基础容器是否属于哈希容器，若是则将 key/element 位置的 `Any` 自动替换为 `AnyHashable`
- **新增** import 注入逻辑：当骨架中包含 `AnyHashable` 时，自动添加 `import temp_test.runtime.AnyHashable`

### 3. `src/java/translation/cangjie_compilation_validation.py` — 编译验证

- **新增** 同样的 `_HASH_KEY_CONTAINERS` 和 `_HASH_ELEMENT_CONTAINERS` 常量
- **修改** `get_cangjie_type()` 函数：与 create_skeleton.py 完全一致的 AnyHashable 替换逻辑

### 4. `src/java/translation/prompt_generator.py` — LLM 提示词

- 修改

   

  ```
  cangjie-persona
  ```

  ：新增 AnyHashable 相关的翻译规则说明，告知 LLM：

  - `HashMap<Object, V>` → `HashMap<AnyHashable, V>`（不能用 Any）
  - `HashSet<Object>` → `HashSet<AnyHashable>`
  - 构造方式 `AnyHashable(value)` / `AnyHashable.of<T>(value)`
  - 解包方式 `.unwrap()`
  - import 路径 `temp_test.runtime.AnyHashable`

### 5. `src/java/isolation_validation/mock_helper.py` — Mock 辅助

- **新增** 类型映射注释第 5 条：说明 HashMap/HashSet key/element 必须满足 Hashable & Equatable，Any 不满足，需用 AnyHashable

### 6. `src/java/isolation_validation/minimal/mock_helper.py` — 最小 Mock 辅助

- **新增** 同上注释

------

**核心机制**：修改分两层防线——

1. **静态映射表** `fixed_type_map.json`：直接将 `HashMap`、`HashSet` 等裸类型映射为带 `AnyHashable` 的泛型形式，确保简单查找路径不遗漏
2. **动态替换逻辑** `get_cangjie_type()`：处理运行时递归解析泛型的场景（如 `HashMap<Object, String>` → 递归把 Object 解析为 Any → 检测到 key 位置是 Any → 替换为 AnyHashable），确保带显式泛型参数的输入也不会漏掉