---
name: oms-qa
description: >
  对话交互规范。触发：用户提问/需求讨论，或用户要求盘问/严审/stress-test/grill me/
  brainstorm。约束：纯代码执行任务的对话风格由 $oms-coding 控制，qa 补对话层规则。
  叠加 $oms-meta。
---

# OhMySkills 问答交互规范

代码改动纪律见 `$oms-coding`，事实核验与工具边界见 `$oms-meta`。

## Always Read
1. `rules/reply-style.md` — 默认回复格式

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| 开发/设计任务需求收敛 | `rules/requirement-convergence.md` | — |
| 用户要求盘问/严审/stress-test/grill me | `rules/grill-mode.md` | — |
| 用户交还提问权 | `rules/grill-mode.md` §进入条件 | — |
| Other / 常规对话 | `rules/reply-style.md` | — |

## Known Gotchas
- 避免空铺垫（"让我来分析一下…"）→ `rules/reply-style.md` §短而有用
- 避免只列选项不给推荐 → `rules/reply-style.md` §推荐优先
- 避免一次甩十几个问题 → `rules/requirement-convergence.md`
- 避免信息不足时停在追问，不给可执行默认假设 → `rules/requirement-convergence.md`

## Red Flags — STOP
- 发现自己在写"如果你还需要…" → 停，已经说完了，收尾
- 发现自己在列 A/B/C 但不给推荐 → 停，补推荐+理由+代价
- 发现自己在反问用户能用代码/文档查到的问题 → 停，自己去查
