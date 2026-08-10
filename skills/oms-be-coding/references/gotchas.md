# 后端已知陷阱

本文件记录来自真实失败的教训。格式：标题、触发场景、根因、避免方式。禁止凭空编造。

---

# 安全陷阱

## handler-authz-scatter（鉴权散落）

**触发**：在 handler 里判断 `if (user.role !== 'admin') return 403`

**根因**：每次新加 handler 都可能忘记加判断，散落的权限逻辑不可审计。

**避免**：authz 统一到 middleware/guard/interceptor，handler 只处理业务。

## txn-external-call（事务内外部调用）

**触发**：在数据库事务内调用 HTTP API 或发送邮件

**根因**：外部调用慢/失败会撑长事务，锁住行/表，连锁故障。

**避免**：先提交事务再做外部调用；或使用异步补偿模式。

# 数据陷阱

## n-plus-one（N+1 查询）

**触发**：
```typescript
const users = await User.findAll();
for (const u of users) await u.getOrders(); // N 次查询
```

**避免**：eager load / JOIN / dataloader / 批处理。

---

<!-- 以下从真实失败中持续捕获 -->
