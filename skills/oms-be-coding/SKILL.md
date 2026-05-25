---
name: oms-be-coding
description: 触发：后端代码改动 (.go/.java/.kt/.py/.ts(Node)/.rs/.cs/.php/.rb/.sql)；后端项目编码任务 (express/nestjs/spring/django/flask/fastapi/gin/actix 等)。OhMySkills 后端领域规范：API 契约、数据层、错误可观测性、并发韧性、安全配置、后端验证。叠加在 $oms-coding 之上。
---

# 后端编码规范 | Backend Coding

本 skill 只补后端专属规则，通用执行纪律见 `$oms-coding`，元规则见 `$oms-meta`。冲突时本 skill 的后端细节优先。

## 1. API 与契约

- API 即契约：请求/响应/错误结构必须有 schema、OpenAPI、Protobuf 或等价定义。
- 错误响应统一结构，HTTP 状态码语义正确；禁止全部返回 200 再塞业务 code。
- 鉴权认证（authn）和授权（authz）分层处理，优先 middleware/guard/interceptor，不在 handler 里散落判断。
- 删除/改名字段要有迁移策略；除非用户明确要求，不写隐藏兼容旧字段的兜底。
- 跨服务契约改动要同步检查调用方、客户端生成物、测试和文档。

## 2. 数据层

- 事务边界短而明确；事务内不要做外部 HTTP/RPC、发邮件、长耗时计算。
- 写操作优先用数据库唯一约束、幂等 key、`ON CONFLICT` 等保证并发正确性。
- 防 N+1：列表/批量查询显式审查 eager/lazy、JOIN、IN、dataloader 或批处理。
- schema 变更走迁移工具；新增高频查询同步考虑索引，删除字段同步处理索引/约束。
- SQL/命令/查询必须参数化或使用安全 builder，禁止字符串拼接不可信输入。

## 3. 错误与可观测性

- 区分 domain error、infra error、unexpected error；不同类别对应不同处理策略。
- 捕获错误必须 log、wrap、return 或 rethrow；禁止空 catch、`except: pass`、忽略 err。
- 日志结构化，包含 request/trace/user/service 等上下文；不要用裸 `print` / `console.log` 代替日志。
- 新接口或关键路径同步考虑指标、trace、错误率和延迟观测。
- 失败要 fail fast 或显式降级；不要僵死、假成功或静默丢任务。

## 4. 并发与韧性

- 共享状态必须有明确锁、事务、队列、actor、channel 或无共享设计。
- 异步任务必须有超时、重试策略、幂等保护和失败可见性；禁止裸 fire-and-forget。
- 外部调用配置超时、重试、限流或熔断；重试必须避免放大故障。
- 资源池（DB/HTTP/thread/goroutine）容量和超时显式配置，生产路径不依赖危险默认值。

## 5. 安全与配置

- 输入校验在系统边界：handler/controller/consumer 层先校验，再进 service/DAO。
- 密码用 bcrypt/argon2/scrypt 等安全哈希；禁止 md5/sha1/明文/自造算法。
- token、密码、身份证、手机号、银行卡等敏感信息日志脱敏，存储和传输加密。
- 配置外置到环境变量、配置中心或密管；禁止硬编码生产地址、密钥、开关和阈值。
- `.env.example` 只放占位符，不放真实或可用凭证。

## 6. 后端验证

- 优先跑目标单测、契约测试、集成测试或相关模块测试；可控时给单测 60 秒超时。
- API 改动验证“请求校验 -> service -> persistence/外部调用 -> 响应/错误结构”链路。
- 数据迁移优先 dry-run、本地库或测试库验证；说明回滚策略和兼容窗口。
- 安全相关改动至少检查越权、注入、敏感日志、默认配置四类风险。
- 环境缺失时说明缺什么、已做哪些代码/契约检查、需要用户在哪个环境复测。

## 反 anti-patterns

- ❌ handler 内散落权限判断。
- ❌ 捕获异常后返回成功或空结果。
- ❌ 事务里调用外部服务。
- ❌ SQL 字符串拼接用户输入。
- ❌ 裸 `go func` / `setTimeout` / background task 无超时和失败记录。
- ❌ 生产配置、token、连接串硬编码进代码或 `.env.example`。
