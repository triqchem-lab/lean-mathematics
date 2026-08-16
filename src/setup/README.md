# 环境 Setup 配置备份

本目录是「环境搭建」相关配置的备份副本（定位参考 `haskell-actions/setup` —— 一个 setup 工具链的 action）。

| 文件 | 作用 |
|---|---|
| `setup-lean/action.yml` | 安装 Lean 工具链 + mathlib cache 的 composite action |
| `lean-toolchain` | Lean 工具链版本锁定 |
| `lakefile.toml` | mathlib 依赖声明 |
| `lake-manifest.json` | 传递依赖 rev 锁定 |
| `.gitmodules` | math 子模块配置 |

## 维护

改了源配置后，**人工**把对应文件复制到本目录，保持备份与源一致。
