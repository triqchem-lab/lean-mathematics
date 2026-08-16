#!/usr/bin/env bash
# 方向一致性检查 (GF(3) 离散第一性 + 0-postulate + 禁浮点)。
#
# 硬违反 → 失败 (方向不一致, 拒绝):
#   1. postulate / axiom / sorry / admit  (违反 0-postulate)
#   2. 浮点类型 (Float/Double/OfScientific) 或浮点字面量 (违反宪法禁浮点)
# 核心层改动 → 提示须 owner review (不自动失败, 由 CODEOWNERS 强制)
#
# 用法:
#   bash scripts/direction-check.sh <base> <head>
# 缺省 base=origin/main, head=HEAD。
set -uo pipefail
BASE="${1:-origin/main}"
HEAD="${2:-HEAD}"
fail=0

# PR 新增/修改的 .lean 文件
files=$(git diff --name-only "$BASE" "$HEAD" -- '*.lean' 2>/dev/null)

if [ -z "$files" ]; then
  echo "DIRECTION OK (无 .lean 改动)"
  exit 0
fi

for f in $files; do
  [ -f "$f" ] || continue
  # 0-postulate 硬违反
  if grep -nE '\b(postulate|axiom|sorry|admit)\b' "$f" 2>/dev/null; then
    echo "❌ 方向违反 (0-postulate): $f 含 postulate/axiom/sorry/admit"
    fail=1
  fi
  # 禁浮点硬违反
  if grep -nE '\b(Float|Double|OfScientific|Float32|Float64)\b|[0-9]+\.[0-9]+' "$f" 2>/dev/null; then
    echo "❌ 方向违反 (禁浮点): $f 含浮点类型或浮点字面量"
    fail=1
  fi
done

# 核心层改动提示 (不 fail, 由 CODEOWNERS 强制 owner review)
core=$(printf '%s\n' "$files" | grep -E 'LeanMathematics/(Base|Structology|Algebra|Coupling|HoTT|Physics|Constitution)/' || true)
if [ -n "$core" ]; then
  echo "⚠️ 核心离散第一性层改动, 须 @clearnature review:"
  echo "$core" | sed 's/^/   /'
fi

if [ $fail -ne 0 ]; then
  echo "DIRECTION FAIL"
  exit 1
fi
echo "DIRECTION OK"
