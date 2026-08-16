# LeanMathematics

律算合一（Sovereign Mathematics）的 **Lean 4 形式化库** —— 与 Agda 库
[`discrete-mathematics/src/Sovereign`](https://github.com/triqchem-lab/discrete-mathematics) 双轨互证。

> 一切假设、理论、概念并存。本库不裁决任何物理理论的正误，只把每条理论线**能落链的部分**写成 0-postulate 定理，并严格区分「代数刚性 / 框架解读 / 实验锚定」。

## 前置

- Lean 4（`v4.34.0-rc1`，见 `lean-toolchain`）
- [mathlib4](https://github.com/leanprover-community/mathlib4)（`master`，与工具链对齐）

## 构建

```sh
lake update   # 物化依赖
lake build    # 编译全库
```

**本地离线开发**：`lakefile.toml` 默认指向本地已下载的 mathlib4（`../leanprover/mathlib4`）。
**发布/外部构建**：按 `lakefile.toml` 顶部注释，切换为 `git require`。

## 结构

镜像 Agda 库 `Sovereign` 的 26 个学术层（PascalCase，对齐 mathlib 惯例）：

| 层 | 内容 |
|----|------|
| `Base` | GF(3) 三进制公理、不变量（POLAR=144 / TORUS=46 / CHERN=±2）|
| `Algebra` | GF(9)=GF(3)[x]/(x²+1)、Frobenius σ、伽罗瓦桥 |
| `RootMath` | 爱森斯坦整数环 Z[ω] |
| `Structology` | T⁶ 环面 ≃ Fin 729、A₄ 群与不可约表示论、缠绕数 |
| `HoTT` | T⁶ 同伦、陈类 |
| `Physics` | 熵旋定律、离散 Maxwell、右旋中微子定理、不可见自由度计数、实验锚定 |
| `Coupling` | 宇称不守恒、自旋=手征投影 |
| `MetaStructure` / `Topology` / `Quantum` / `Geometry` / `Coding` / `Constitution` | 五行、高维闭包、射影/共形、编码、宪法边界 |
| `Problem` | 千禧问题层（BSD / Riemann / PvsNP / NavierStokes / YangMills …）|
| `AI` / `Engine` / `Diagnosis` / `Trust` / `Density` / `Applied` / `Analysis` / `PDE` / `Completeness` / `Projection` | 工程/宪法/诊断层（镜像 Agda 库，非纯数学，定位见各模块 docstring）|

## 测试

```sh
bash test/structure.sh   # 结构完整性（红/绿：26 层 + 49 存根 + 聚合器 import 校验）
```

## 许可

[MIT](./LICENSE)
