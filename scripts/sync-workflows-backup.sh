#!/usr/bin/env bash
# 同步 .github/workflows/ + .github/actions/ → src/workflows/ (备份副本)。
# GitHub Actions 只读 .github/workflows/, 本目录仅作存档。
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1

rm -rf src/workflows
mkdir -p src/workflows
cp .github/workflows/*.yml src/workflows/
cp -r .github/actions src/workflows/actions

echo "已同步 .github/workflows + .github/actions → src/workflows/"
