# 治理：合并控制权与方向一致性

> 本库是 **GF(3) 三进制离散第一性**形式化库，与传统实数/连续统形式化方向不同。
> 本文定义：谁控制合并、哪些 PR 可自动合并、哪些受限。

## 治理原则

1. **owner 控制权**：核心离散第一性本体层（GF(3) 公理、T⁶ 环面、144/46 缠绕、主权 LCM）
   的最终决定权在 owner（@clearnature）。
2. **方向一致性优先于开放**：欢迎「一致方向」的形式化贡献；「不一致方向」的贡献即使
   能编译也受限（见下文清单）。
3. **0-postulate 是底线**：`postulate` / `axiom` / `sorry` / `admit` 一律拒绝。

## 四层控制机制

| 层 | 机制 | 作用 |
|---|---|---|
| 1 | 分支保护（branch protection） | `main` 只进 PR；要求 status checks + review 通过 |
| 2 | `CODEOWNERS` | 核心层（Base/Structology/Algebra/Coupling/HoTT/Physics/Constitution）改动必须 owner review |
| 3 | `direction-check`（workflow） | 自动拦截硬违反：postulate/axiom/sorry/admit + 浮点 |
| 4 | `auto-merge`（label 触发） | owner 加 `direction-consistent` label 后，CI 全绿即自动 squash 合并 |

## Label 语义

| Label | 含义 | 谁打 |
|---|---|---|
| `direction-consistent` | 方向一致，授权自动合并 | owner（review 通过后） |
| `needs-review` | 需人工审查（默认状态） | owner / 自动 |
| `direction-rejected` | 方向不一致，拒绝 | owner |

## 可提交（一致方向 ✅）

- GF(3) 三进制 / ZMod 3 / GF(9)=GF(3)[x]/(x²+1) 等有限域结构
- T⁶ 离散环面、144×46=6624 缠绕、主权 LCM 3¹¹·2¹⁶
- 0-postulate **构造性**证明（`refl`/`decide`/有限 case 枚举）
- 定点整数比数值验证（禁浮点，√3 用 173205/100000）
- 镜像 Agda 库 `discrete-mathematics` 的已有定理

## 受限（不一致方向 ⛔）

- 任何 `postulate` / `axiom` / `sorry` / `admit`
- 浮点数（`Float`/`Double`/浮点字面量）——无理数须定点整数比
- 传统实数连续统、标量场（本库约定量子场 = 向量场，见 94-pleiadian 修正）
- 破坏 144/46 全息 π 不约分、十二律长度表静态
- 非离散的朴素重编码（离散第一性本体只在 Agda 原生，Lean 侧需先开发插件）

## 自动合并流程

1. 贡献者开 PR（方向一致的贡献）；
2. CI 跑 `direction-check` + `formal-test`（证明/数值/结构/风格）；
3. owner review：方向一致 → 加 `direction-consistent` label；
4. `auto-merge` workflow 触发 `gh pr merge --auto`；
5. 所有 required checks 绿后自动 squash 合并。

> 控制权保证：只有能打 label 的成员（owner）能触发第 3 步；`direction-check`
> 在合并前拦截一切硬违反；核心层改动还额外受 `CODEOWNERS` review 约束。
