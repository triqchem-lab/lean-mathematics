#!/usr/bin/env bash
# 备份 .github/ 配置到 src/ (存档副本, 非 CI 读取源)。
#   .github/workflows/ + .github/actions/ → src/workflows/
#   .github/ 其余配置 (CODEOWNERS / PULL_REQUEST_TEMPLATE 等) → src/github/
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

# workflows + actions → src/workflows/
rm -rf src/workflows
mkdir -p src/workflows
cp .github/workflows/*.yml src/workflows/
cp -r .github/actions src/workflows/actions

# 其余配置 (目录下的一级文件) → src/github/
rm -rf src/github
mkdir -p src/github
for f in .github/*; do
  [ -f "$f" ] && cp "$f" src/github/
done

echo "已备份 .github/ → src/workflows/ + src/github/"
