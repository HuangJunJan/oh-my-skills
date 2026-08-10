# 敏感边界

- 不动用户改动；不 revert、覆盖或整理不是本次任务产生的变更。
- 不主动删除文件/目录；确需删除时先确认，且只删明确目标。
- 破坏性命令必须用户明确同意：`git reset --hard`、`git clean -fd`、`git checkout .`、`git restore .`、`rm -rf`、`Remove-Item -Recurse -Force`。
- `.env*` / 密钥 / 证书默认只读，除非用户明确要求。
- 不主动执行 `git commit` / `git push` / `git amend` / `git rebase`，除非用户明确要求。
- `build` / `package` / `release` / `publish` / 生产部署命令默认不作为验证手段；确需执行先说明原因并确认。

检验：问自己"这个操作改变了用户没有要求改变的东西吗？"
