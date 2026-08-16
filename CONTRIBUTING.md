# 贡献指南

## 仓库纪律

1. **0-postulate**：证明一律构造性闭合；实验锚定（轨道 B）须附来源并在注释标注，不得冒充定理。
2. **先算后写**：写证明前先手算/数值核算；检查器就是裁判，不伪造 `refl`/`by`。
3. **诚实边界**：能推导的写定理、能计算的写表格、属于解读的写进模块 docstring 的"诚实边界"节。
4. **双轨互证**：本库每个定理在 Agda 库 `discrete-mathematics` 有对应；改 Lean 侧时同步核对 Agda 侧结果。

## 提交流程

```sh
lake build                      # 编译通过
bash test/structure.sh          # 结构测试绿
```

- 提交信息中文，格式 `feat:` / `fix:` / `docs:` / `refactor:`。
- 发布前把 `lakefile.toml` 的本地 `path` 依赖切为 `git require`（见顶部注释）。

## 模块规范

- 目录/模块命名 PascalCase，对齐 mathlib（`Mathlib.Algebra.Group`）。
- 模块 docstring `/-! ... -/` 置于 import 之后，说明数学背景与镜像的 Agda 模块。
- 分层：`Base`/`Algebra`/`Structology`/`Physics` 为纯数学层；`AI`/`Engine`/`Diagnosis`/`Trust` 等为工程/宪法层，各自 docstring 注明定位。

## 许可

MIT。贡献即视为同意以 MIT 授权。
