# Add API 工作流

## Task Anchor（任务锚点）

**Goal:** 按契约新增 API 端点，包含鉴权、校验、可观测性。

**Boundaries:**
- 不修改已有接口的行为和状态码
- 不散落权限判断在 handler 里
- 不硬编码密钥/生产地址

**Done When:**
- 请求/响应/错误结构符合契约定义
- 鉴权分层（middleware/guard），不在 handler 散落
- 日志结构化，错误分类
- 安全校验完成（注入/越权/敏感数据）
- AAR 扫描完成

---

## Step 1 — 确认契约
- 请求/响应/错误结构定义（OpenAPI / Protobuf / schema）
- HTTP 方法、路径、状态码
- 读 `rules/api-contract.md`

## Step 2 — 鉴权
- authn + authz 分层，优先 middleware/guard/interceptor
- 不在 handler 里散落权限判断
- 读 `rules/security-config.md`

## Step 3 — 实现
- handler 层：输入校验
- service 层：业务逻辑
- 数据层：读 `rules/data-layer.md`
- 读 `$oms-coding/rules/code-quality.md`

## Step 4 — 可观测性
- 日志结构化
- 错误分类（domain / infra / unexpected）
- 读 `rules/error-observability.md`

## Step 5 — 验证
- 目标测试 / 契约测试 / 集成测试
- 验证链路：请求校验 → service → persistence → 响应/错误结构
- 读 `rules/security-config.md` 检查越权/注入/敏感日志

## Step 6 — 交付
- 走 `$oms-meta/workflows/task-closure.md` AAR

### Gotcha 检查
- [ ] authn + authz 分层，不在 handler 散落
- [ ] 错误结构统一，状态码语义正确
- [ ] 没有空 catch / except: pass
- [ ] 敏感数据日志脱敏
- [ ] 没有硬编码密钥/生产地址