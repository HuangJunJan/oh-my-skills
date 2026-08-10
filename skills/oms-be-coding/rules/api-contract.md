# API 与契约

## 核心规则

- API 即契约：新增请求/响应/错误结构必须有 schema、OpenAPI、Protobuf 或等价定义。
- 新增 API 默认使用统一错误结构和语义正确的 HTTP 状态码；维护既有 API 时，不擅自改变历史状态码、错误格式和字段语义。
- 鉴权认证（authn）和授权（authz）分层处理，优先使用 middleware/guard/interceptor，不在 handler 里散落判断。
检验：新增的接口能被"删掉 auth middleware"绕过吗？— 能就说明 authz 散落在 handler 里。
- 删除/改名字段要有迁移策略；除非用户明确要求，不写隐藏兼容旧字段的兜底。
- 跨服务契约改动要同步检查调用方、客户端生成物、测试和文档。
