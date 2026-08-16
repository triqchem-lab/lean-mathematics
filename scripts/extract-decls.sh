#!/usr/bin/env bash
# 提取库的顶层声明清单 (kind + 名字), 作为「形式化 API 表面」。
# 形式化库里定理/定义名 = API; decls-diff 用它让增删改在 PR 里可见。
# 轻量版 (grep 顶层声明) — 对照 mathlib4 的 decls-diff (基于 Lean import-graph),
# 后者对 49 模块的 stub 库过重, 此脚本随库成长可逐步替换为精确版。
set -euo pipefail
ROOT="${1:-LeanMathematics}"

for f in $(find "$ROOT" -name '*.lean' | sort); do
  # 只匹配行首 (无缩进) 的顶层声明, 避免匹配定理体内部的引用
  grep -hE '^(theorem|lemma|def|abbrev|structure|inductive|class|instance|notation|infix|infixl|infixr|macro|elab|axiom)[[:space:]]+' "$f" 2>/dev/null || true
done | sed -E 's/^(theorem|lemma|def|abbrev|structure|inductive|class|instance|notation|infix|infixl|infixr|macro|elab|axiom)[[:space:]]+([^[:space:]:=(]+).*/\1 \2/' | sort -u
