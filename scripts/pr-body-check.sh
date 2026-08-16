#!/usr/bin/env bash
# 校验 PR body 是否勾选了全部方向一致性声明。
# body 通过环境变量 BODY 传入 (含换行, 避免 shell 转义问题)。
# 5 项声明须全部 - [x] 勾选, 否则失败。
set -uo pipefail
body="${BODY:-}"
fail=0

for item in "方向一致" "0-postulate" "禁浮点" "镜像 Agda" "本地验证通过"; do
  if ! printf '%s\n' "$body" | grep -qE "\[x\]\s*\*\*${item}\*\*"; then
    echo "❌ 声明未勾选: $item"
    fail=1
  fi
done

if [ $fail -ne 0 ]; then
  echo "请在 PR 描述中勾选全部声明 (见 .github/PULL_REQUEST_TEMPLATE.md)"
  exit 1
fi
echo "PR 声明 OK (5/5 勾选)"
