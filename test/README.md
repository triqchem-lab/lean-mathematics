# 测试用例

用户可自由添加的测试用例。**math 是 git 子模块（只读依赖，用户不改其本体）**，
测试全部写在 `lean-mathematics/test/`，依赖 math 的头文件/Crate。

## 目录

```
test/
├── cpp/            C++ 数值验证 (cmake glob *.cpp → ctest)
├── rust/           Rust 数值验证 (cargo test, #[test])
└── structure.sh    结构完整性 (红/绿)
```

Lean 定理的「测试」就是 `lake build`（类型检查器即裁判，见 docs/CI-DIAGNOSIS.md）。

## 分类约定

| 类别 | 测什么 | 判定 |
|---|---|---|
| **数值正确性** (correctness) | 整数锚点精确相等（144/46/6624/C=±2/3¹¹·2¹⁶） | 严格相等，对照形式化定理 |
| **数值精度** (precision) | 定点有理逼近代数数（√3 = 173205/100000） | 整数误差界，全程禁浮点 |

## 如何添加

- C++：在 `test/cpp/` 放一个 `xxx.cpp`（含 `main` 或断言），CMake 自动收集为 ctest。
- Rust：在 `test/rust/src/lib.rs` 加 `#[test] fn ...`。
- Lean：在 `LeanMathematics/` 加定理，`lake build` 即验证。

## 高精度对比（按需加，非必需）

- 正确性复核：`malachite`（纯 Rust 大整数，零 C 依赖，最贴合宪法）。
- 精度参考：`rug`（MPFR 绑定），仅对 √3/ω 等少数代数数算一次参考常数。
- **不用 npm**（JS 生态无关）；**不用符号计算**（形式化层已是权威 oracle，sympy 冗余）。
