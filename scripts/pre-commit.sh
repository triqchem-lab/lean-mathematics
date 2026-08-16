#!/usr/bin/env bash
# pre-commit hook: 快速门禁 (lake build + 结构测试)。lint 仅留在 CI。
set -e
cd "$(git rev-parse --show-toplevel)" || exit 1
export PATH="$HOME/.elan/bin:$PATH"

if ! lake build >/dev/null 2>&1; then
  echo "pre-commit: lake build FAIL — 提交被拦截" >&2
  exit 1
fi

if ! bash test/structure.sh >/dev/null 2>&1; then
  echo "pre-commit: structure test FAIL — 提交被拦截" >&2
  exit 1
fi

exit 0
