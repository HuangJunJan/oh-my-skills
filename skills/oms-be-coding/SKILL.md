---
name: oms-be-coding
description: >
  后端代码改动 (.go/.java/.kt/.py/.ts(Node)/.rs/.cs/.php/.rb/.sql)；后端项目
  (express/nestjs/spring/django/flask/fastapi/gin/actix)。关键词：接口/API/数据库/
  SQL/ORM/migration/后端。需配合 $oms-coding + $oms-meta。仅当任务涉及后端编码时加载。
---

# OhMySkills 后端编码规范

本 skill 只补后端专属规则，通用执行纪律见 `$oms-coding`，元规则见 `$oms-meta`。
冲突时本 skill 的后端细节优先。

## Always Read
1. `rules/api-contract.md` — API 契约与错误结构
2. `rules/security-config.md` — 安全与配置

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| Add API / 新增接口 | `rules/api-contract.md` | `workflows/add-api.md` |
| 数据库 schema 变更 | `rules/data-layer.md` | `workflows/db-migration.md` |
| Fix bug（后端） | `$oms-coding` rules + `rules/error-observability.md` | `$oms-coding/workflows/fix-bug.md` |
| 并发/异步改造 | `rules/concurrency.md` | — |
| Other | `rules/api-contract.md` + `rules/security-config.md` | 按最接近的 workflow |

## Known Gotchas
- Handler 内散落权限判断 → 用 middleware/guard/interceptor
- 事务内调用外部 HTTP/RPC → 拆开或用异步补偿
- 捕获异常后返回成功或空结果 → 见 `$oms-coding/rules/debugging.md`
- SQL 字符串拼接不可信输入 → 参数化查询
- 裸 go func / setTimeout 无超时和失败记录 → `rules/concurrency.md`
- 生产配置/密钥硬编码 → `rules/security-config.md`

## Red Flags — STOP
- "这个接口先不加鉴权，后面再补" → 停，鉴权必须从第一行就加
- "事务里做个 HTTP 调用问题不大" → 停，事务内禁止外部调用
- "这个异常 catch 一下返回 null 就行" → 停，读 `$oms-coding/rules/debugging.md`
