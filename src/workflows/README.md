# 工作流备份

本目录是 `.github/workflows/` 与 `.github/actions/` 的**备份副本**，非 CI 读取源
（GitHub Actions 只读 `.github/workflows/`，本目录仅作存档与参考）。

- 源：`.github/workflows/*.yml` + `.github/actions/setup-lean/`
- 备份：本目录

## 同步

改了源 workflow 后运行：

```sh
bash scripts/sync-workflows-backup.sh
```

即可把最新 workflow 同步到本目录。
