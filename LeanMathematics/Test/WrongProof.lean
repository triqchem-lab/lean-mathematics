import Mathlib

/-! 反例: 错误证明 — 假命题 (1=0 in ZMod 3) 必须被 lake build 捕获 -/

theorem wrong_proof : (1 : ZMod 3) = 0 := by
  native_decide
