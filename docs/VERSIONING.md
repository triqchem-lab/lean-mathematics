# 版本管理：工具链与依赖稳定性

> 本库是形式化证明库，定理能否编译取决于 **Lean 4 工具链 + mathlib4 依赖** 的精确版本。
> 本文说明版本如何被锁定、为何稳定、以及如何安全升级。

## 三层版本锁定

| 层 | 文件 | 锁定内容 | 作用 |
|---|---|---|---|
| 编译器 | `lean-toolchain` | `leanprover/lean4:v4.34.0-rc1` | elan / lean-action 据此安装**精确版本**，非 `latest` |
| 依赖树 | `lake-manifest.json` | mathlib4 rev `274ed6d…` + 全部传递依赖（plausible / LeanSearchClient / import-graph …）的精确 rev | `lake build` 据此物化依赖，不会漂移 |
| 声明 | `lakefile.toml` | `[[require]] rev = "274ed6d…"` | 声明 mathlib4 依赖的起始 rev |

三个文件**均已 git 跟踪**（`git ls-tree HEAD` 可查），是版本稳定的唯一真相来源。

## 关键绑定：mathlib4 rev ↔ Lean 版本

mathlib4 的每个 commit 自带 `lean-toolchain`，声明它需要哪个 Lean 4 版本。
因此 **`rev` 与 `lean-toolchain` 必须成对一致**：

- 实测：mathlib4 @`274ed6d` 声明的工具链 = `leanprover/lean4:v4.34.0-rc1`，与本库 `lean-toolchain` **完全一致** ✅
- 若两者不一致，`lake build` 会在物化依赖时直接报「工具链不匹配」。

## 为什么稳定（每次构建同一套版本）

1. CI 的 `lean-action` 读 `lean-toolchain` → 安装精确版本（非 latest）；
2. `lake update` / `lake build` 读 `lake-manifest.json` → 使用锁定的 rev；
3. 结论：只要三个文件不改，本地与 CI 每次都是同一套版本。

## 升级流程（何时、如何改）

### 自动（推荐）

`update.yml` 每周日 `lean-update` 自动 bump，**同时**更新 `lean-toolchain` + `lake-manifest.json`
（保持绑定），并开 PR 供 review —— 不自动 merge。审查通过后合并即完成升级。

### 手动（需成对改）

1. 查 mathlib4 目标 commit 自带的 `lean-toolchain`（`raw.githubusercontent.com/…/<rev>/lean-toolchain`）；
2. 把本库 `lean-toolchain` 改成该版本；
3. 把 `lakefile.toml` 的 `rev` 改成该 commit；
4. 本地 `lake update`（重新生成 `lake-manifest.json`）→ `lake build` 验证；
5. 提交这三个文件。

> ⚠️ 只改其一、不改另一，会导致构建失败。

## 风险与取舍

- `v4.34.0-rc1` 是 **release candidate（预发布）**。这是 mathlib4 的常态（紧跟 Lean 最新版，含 rc）。
  **rev 固定 = 行为固定**，rc 名字本身不影响稳定性。
- 若要「最稳」，可等 mathlib4 的稳定快照（stable tag）再升级；代价是短期不跟进上游修复。
- 本地离线开发：`lakefile.toml` 可临时把 `git` 改成本地克隆的 `file://` URL，**提交前必须改回 git 形式**（见 `lakefile.toml` 顶部注释）。
