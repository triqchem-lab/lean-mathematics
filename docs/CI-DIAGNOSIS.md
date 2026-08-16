# CI 错误定位：流程问题 vs 证明问题

> 判定总原则：**Lean/Agda 的类型检查器就是裁判**。
> `lake build`（Lean）或 `agda <file>`（Agda）非零退出 = 证明问题；
> 其余任何环节失败 = 流程/环境/风格/结构问题。

## 判定表

| CI 环节 | 失败含义 | 类型 |
|---|---|---|
| `lake update`（拉 mathlib） | 钉扎 commit 失效 / 网络 / 缓存未命中 | **流程问题** |
| `lake build`（Lean 类型检查） | 定理未 typecheck：有洞、类型错误、证错 | **证明问题** ✅ 唯一信号 |
| `lint-style.py` | 行长 / 尾部空白 / 文件头风格 | 风格问题（非证明） |
| `test/structure.sh` | 目录 / 模块 / import 结构漂移 | 结构问题 |
| C++ `cmake` / `ctest` | 数值核验失败 | 数值验证问题 |
| Rust `cargo test` | 数值核验失败 | 数值验证问题 |
| workflow YAML（0 job 即失败） | YAML 语法错误（如 `name:` 值含 `: `） | 流程问题 |
| lean-action / toolchain 安装失败 | 工具链版本不匹配 | 流程问题 |
| 克隆 math 库失败 | 仓库不存在 / 网络 / 权限 | 流程问题 |

## 三秒定位法

1. GitHub Actions 点开红色 run；
2. 看哪个 step 是红 X；
3. 对上表即得类型。

## 证明问题的唯一信号

`lake build` 输出 `error: ...` 且**指向某个 `.lean` 文件的某一行**——
这是类型检查器拒绝了证明。只有这一类代表「证明有问题」；其余全是环境/流程。

## 本地对应（Agda 库，纯本地开发）

- `agda src/Sovereign/All.agda` 非零退出 → 证明问题（类型检查器拒绝）。
- `make -B test` 非 ALL_PASS → 测试集里某模块证明问题。
- 二者之外（库注册、import 顺序、flag 冲突）→ 流程问题。

## 实证案例（本仓库历史）

| 现象 | 判定 |
|---|---|
| CI 0 job 直接 failure（首推） | 流程问题：模板 node.js.yml 的 `setup-node` 缓存 npm 依赖，仓库无 package.json |
| `name:` 值含 `: ` 导致 YAML 解析失败 | 流程问题 |
| `lake build` 8778 jobs 绿 + 第一条定理 typecheck | 证明正确 |
