# CODEX.md

正式文档在 `skills/` 目录下。每个任务先读 `skills/*/SKILL.md`，默认加载 `oms-meta`
+ `oms-coding` + `oms-qa`；按任务类型追加 `oms-be-coding` / `oms-fe-coding` / `oms-review`。

## 快速路由表（上下文压缩后仍能存活）

| 任务 | 必读 | 流程 |
|------|------|------|
| 修 bug | `oms-coding/rules/debugging.md` + `oms-coding/rules/fix-strategy.md` | `oms-coding/workflows/fix-bug.md` |
| 新功能 | `oms-coding/rules/code-quality.md` + 领域规则 | `oms-coding/workflows/add-feature.md` |
| 加接口 | `oms-be-coding/rules/api-contract.md` | `oms-be-coding/workflows/add-api.md` |
| 数据库迁移 | `oms-be-coding/rules/data-layer.md` | `oms-be-coding/workflows/db-migration.md` |
| 加页面/组件 | `oms-fe-coding/rules/state-dataflow.md` | `oms-fe-coding/workflows/add-page.md` |
| 接口对接 | `oms-fe-coding/rules/api-integration.md` | `oms-fe-coding/workflows/integrate-api.md` |
| 代码审查 | `oms-review/SKILL.md` | `oms-review/workflows/review.md` |
| 多子任务（≥3） | `oms-coding/rules/code-quality.md` | 派发干净 worker |
| 其他 | `oms-coding/rules/code-quality.md` + `oms-coding/rules/sensitive.md` | 找最接近的 workflow |

## 自动触发器

- **同一会话新任务** → 重读 `skills/oms-*/SKILL.md`，重新匹配路由，重读所有必读文件。
  "我已经读过了"不是理由——上下文会被压缩，路由因任务而不同。
- 任何非琐碎任务声明"完成"前 → 走 Task Closure Protocol
  （`skills/oms-meta/workflows/task-closure.md`）
- 仅以下情况跳过：纯格式化、纯注释、纯依赖版本变更、无新教训的重构

## 红线 — 立即停止

- "就这一次跳过 AAR" → 停，走 Task Closure Protocol
- "这个 catch 只是以防万一" → 停，读 `oms-coding/rules/debugging.md`
- "顺便格式化/重命名/升级依赖" → 停，撤销无关改动
- "先加个 any 跑通再说" → 停，用 `unknown` + 类型守卫
- "鉴权后面再补" → 停，鉴权必须从第一行就加