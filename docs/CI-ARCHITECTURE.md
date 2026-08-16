# CI 架构与决策记录

> 本文记录 `lean-mathematics` 的 CI 架构（借鉴 mathlib4 / physlib 实践）与关键决策。
> 错误定位另见 `docs/CI-DIAGNOSIS.md`，版本管理见 `docs/VERSIONING.md`。

## 能力一览（这套 CI 能自动完成什么）

1. **证明正确性**：`lake build`（Lean 类型检查器 = 唯一裁判）——定理有洞/证错/类型错即失败。
2. **数值锚点正确性**：C++ `ctest` + Rust `cargo test` 核对整数锚点（144/46/6624/LCM）与定点 √3。
3. **结构/风格/API 漂移检测**：`structure.sh`（26 层 + 49 模块 + 孤立 `.lean` 闸）、`lint-style.py`、`decls-diff`（定理名 API diff）。
4. **workflow 自身可靠性**：`actionlint`（YAML + shellcheck）+ `ensure-sha-pinned-actions`（强制 action SHA 固定）。
5. **PR 卫生**：标题约定 `check-pr-titles` + 自动修复 `pre-commit`（lite-action 推回）。
6. **环境自检与预热**：`env-init` / `env-test`（手动或环境文件变更）。
7. **依赖维护**：`update`（每周日自动 bump mathlib4 并开 PR）。

## 架构总览（8 workflow + 1 composite action）

### 门禁类（每次 push / PR 自动触发）

| Workflow | 触发 | 职责 |
|---|---|---|
| `formal-test` | push + PR | **主门禁**：Lean 交叉验证（lake build + lint-style + structure.sh）+ 数值验证（C++ ctest / Rust cargo） |
| `actionlint` | PR 改 `.github/**` | workflow YAML 校验（actionlint）+ 强制 action SHA 固定 |
| `check-pr-titles` | PR title | 标题约定 `<kind>(<scope>): <subject>` + sticky comment |
| `decls-diff` | PR | 声明 API 表面 diff（定理/定义名 = API） |
| `pre-commit` | PR + 非 main push | pre-commit 框架 + lite-action 自动 fix 推回分支 |

### 环境 / 维护类（手动 / paths / schedule）

| Workflow | 触发 | 职责 |
|---|---|---|
| `env-init` | workflow_dispatch + 环境文件变更 | 安装工具链 + 拉依赖 + 预热 olean 缓存 |
| `env-test` | workflow_dispatch + 环境文件变更 | 工具链版本 + Mathlib 导入冒烟 |
| `update` | 每周日 cron + workflow_dispatch | 自动 bump mathlib4 并开 PR（`lean-update`） |

### 复用单元

- `.github/actions/setup-lean/`（composite action）—— 集中 checkout + lean-action 的
  SHA 固定与 cache 配置，三处 workflow 共用，升级 action 版本只改这一处。

## 决策记录

### 1. nolints「零例外」原则（不采用 mathlib4 的 nolints 自动更新）

mathlib4 的 `nolints.yml` 定期跑 `lake lint --update`，把新出现的 lint 错误**加入例外文件**
并自动开 PR。我们**不采用**，理由：

1. 我们 vendored 的 `scripts/lint-style.py` 是**纯 Python text-based** linter，没有
   nolints 例外机制；`scripts/nolints-style.txt` 是 mathlib 自身 Lean linter（`lake lint`）
   的历史例外，与我们的 Python linter 无关。
2. 新库应坚持**零例外**：style 错误直接修，而非加入例外。例外机制会积累历史债务，
   与我们「0-postulate、先算后写」的纪律相悖。

因此 lint 保持「报错即修」——`lint-style.py` 非零退出 → 修风格，不引入例外表。

### 2. action 版本治理（SHA 固定 + 语义版本注释）

借鉴 mathlib4 三件套：所有 `uses:` 固定到 40-hex SHA + 注释标注语义版本，
`ensure-sha-pinned-actions` 强制。杜绝浮 tag（如 `checkout@v4`）底层的 Node 运行时漂移
（2025-09 Node 20 弃用即此类问题）。

### 3. 最小权限 + 公共 mathlib 缓存

三 workflow 统一 `permissions: contents: read`；lean-action 显式
`use-github-cache: false`（避免 actions/cache 的 write 权限需求），mathlib olean 走公共
blob 缓存。仅 `update.yml`（开 PR）和 `pre-commit.yml`（自动 fix）声明写权限。

### 4. decls-diff 用轻量版（grep 顶层声明）

mathlib4 的 decls-diff 依赖 Lean import-graph artifact + mathlib-ci 动作，对 49 个 stub
模块的库过重。当前用 `scripts/extract-decls.sh`（grep 行首顶层声明）对比 base vs head，
随库成长可升级为 import-graph 精确版。
