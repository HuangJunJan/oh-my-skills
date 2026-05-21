---
name: oms-be-coding
description: 后端通用编码规范层——API 设计与契约、数据层与持久化、错误处理与可观测性、并发与异步、安全与合规、配置与部署。叠加在 $oms-coding 之上。触发：后端代码改动(.go/.java/.kt/.py/.ts(Node)/.rs/.cs/.php/.rb/.sql)；后端项目编码任务(express/nestjs/fastify/koa/spring/django/flask/fastapi/gin/echo/actix 等)。
---

# 后端通用编码规范 | Backend Coding Conventions

本 skill 是 OhMySkills 的**后端领域层**，叠加在 `$oms-coding`（跨语言通用编码层）之上。仅承载后端服务（API / 数据 / 并发 / 安全 / 部署）专属规则；跨语言通用规则（复用 / 命名 / 最小改动 / 交付报告等）见 `$oms-coding`。冲突时本 skill 优先。元层规则（优先级 / 平台基线 / 工具能力 / 不确定不假设 / skill 间引用）见 `$oms-meta`。

## A. API 设计与契约 | API Design and Contracts

- **API 即契约**（contract first）：版本化（`/v1`），向后兼容；删字段前先标 `deprecated` 走过渡期，禁直接下线。
- **协议单一**：REST / RPC / GraphQL 选定后项目内不混用（一个微服务内）；跨服务协议在架构层统一。
- **错误响应统一结构**：`{ code, message, details }` 三件套；HTTP 状态码语义正确（4xx 客户端错、5xx 服务端错，禁全返 200 包装 code）。
- **schema 即真相**：请求 / 响应用 OpenAPI / Protobuf / JSON Schema 定义，禁口头约定 / 文档与代码漂移；优先用工具从 schema 生成类型与 client。
- **鉴权统一中间件**：禁 handler 内散落鉴权 / 权限判断；权限粒度到 action（如 `order.refund`）而非角色（如 `admin`）。

## B. 数据层与持久化 | Data and Persistence

- **事务边界明确**：跨服务调用 / 网络 IO 不放事务内；事务尽量短小，否则锁等待 / 连接池耗尽。
- **迁移走 schema 工具**：Flyway / Liquibase / Alembic / Prisma / goose / sqlx-cli 等；禁手改 prod 表 / 临时 SQL 改 schema。
- **N+1 警觉**：ORM 关联默认 `eager` / `lazy` 显式审；列表 / 批量场景用 `JOIN` / `IN` / dataloader 一次取齐。
- **索引与查询同步演进**：关键路径 `EXPLAIN` 检查；新增高频查询同步加索引，删字段同步删索引。
- **写操作幂等**：用唯一约束 / 幂等 key / `INSERT ON CONFLICT` 在 DB 层保护；禁靠业务层 `if exists then update` 自旋（并发下失效）。

## C. 错误处理与可观测性 | Error Handling and Observability

- **错误分层**：domain error（业务可恢复，如「余额不足」）/ infra error（资源失败，如「DB 超时」）/ unexpected（编程错误，如「nil 指针」）三类区分，处理策略不同。
- **错误不吞**：捕获必须 log 或 rethrow，禁空 `catch {}` / `except: pass` / `_ = err` / `_, _ = ...`；吞错误等于线上事故无线索。
- **结构化日志**：JSON 格式，必含 `trace_id` / `request_id` / `user_id` / `service` 等上下文；禁纯字符串 log / `print` / `console.log`。
- **可观测三件套**：metric（耗时 / QPS / 错误率）+ trace（关键路径 span）+ log（结构化），缺一不可；新加接口同步埋点。
- **告警阈值对齐 SLO**：错误率 / P99 延迟阈值与业务承诺挂钩，禁拍脑袋设 100ms / 1% 等魔法数字。

## D. 并发与异步 | Concurrency and Async

- **共享状态明确锁策略**：mutex / RWLock / atomic / channel / 无锁结构，按场景选；禁假定单线程 / 默认无竞态。
- **异步任务三件套**：超时 + 重试（指数 backoff）+ 死信队列；禁裸 `go func(){}` / `setTimeout` / `Thread.start` fire-and-forget。
- **资源池显式**：DB 连接池 / HTTP client / goroutine pool / thread pool 的容量 + 超时 + 空闲回收策略必显式配置，禁默认值上 prod。
- **防雪崩三层**：熔断（fail fast）+ 限流（保护自身）+ 降级（保住核心链路），下游慢时不拖死自身。
- **原生并发原语优先**：用 channel / Future / async / actor 等语言原生工具表达同步；禁 `sleep(100)` 等业务回调（不可靠且不可读）。

## E. 安全与合规 | Security and Compliance

- **输入校验在边界**：handler / controller 层用 schema-based 校验（zod / pydantic / validator / go-playground/validator），禁信任客户端数据传到 service / DAO 层才校验。
- **注入防护**：SQL / Command / LDAP / XPath 必用参数化查询 / 预编译 / escape；**禁字符串拼接 SQL**（`"... where id=" + userId` 是经典漏洞）。
- **敏感数据保护**：密码 / token / 身份证 / 银行卡 / 手机号在日志脱敏 + DB 加密存储 + 网络 TLS 传输；脱敏在序列化层统一处理。
- **密码哈希**：bcrypt / argon2 / scrypt，带 salt；**禁 md5 / sha1 / 明文 / 自造 hash**。
- **authn ≠ authz**：authentication（你是谁）与 authorization（你能做什么）分清；权限到 action 而非角色，避免「admin 全能」反模式。

## F. 配置与部署 | Configuration and Deployment

- **配置外置**：环境变量 / 配置中心（Nacos / Apollo / Consul）；禁硬编码 prod URL / 密钥 / Feature 开关 / 限流阈值。
- **secrets 走密管**：Vault / KMS / AWS Secrets Manager / Doppler；禁明文进 git，`.env.example` 只放占位符（见 `$oms-coding` D 节）。
- **健康检查 + 优雅退出**：`/healthz`（liveness）+ `/readyz`（readiness）+ SIGTERM 处理 + 连接池 drain + 正在处理请求等完成；禁 `kill -9` 式停机。
- **启动幂等**：重复启动不重复初始化数据 / 不重复注册定时任务；启动依赖（DB / 配置中心）失败 fail fast 而非僵死。
- **变更灰度**：配置 / 部署 / 数据迁移走灰度（金丝雀 / 蓝绿 / 比例放量），禁直接全量推 prod；回滚预案与变更同步准备。

## 反 anti-patterns

- ❌ 删 API 字段不标 `deprecated` 直接下线，老客户端 / 老 SDK 炸
- ❌ 事务里调外部 HTTP / RPC / 发邮件，事务时间随网络抖动放大到秒级，锁等待 / 连接池耗尽
- ❌ ORM 关联默认 lazy 在列表渲染时触发 N+1（20 行数据 = 21 次查询）
- ❌ `except Exception: pass` / `catch (e) {}` / `if err != nil { return nil }` 吞错误，线上出问题无任何线索
- ❌ 用 `print` / `console.log` / `fmt.Println` 当日志，无 `trace_id` 无结构无 level
- ❌ 异步任务 `go func(){}` / `setTimeout` 无超时无重试无死信，任务静默丢失
- ❌ SQL 字符串拼接 `"select * from users where id=" + userId`（注入漏洞）
- ❌ 密码 `md5(password)` 存库；`access_token=xxx` 明文写 `.env.example` 提交 git
- ❌ 健康检查只返回 `200 OK` 不检查依赖（DB / 缓存 / MQ），挂了流量仍打进来
- ❌ 限流 / 超时 / 重试次数硬编码在代码里，改 prod 要重新发版
