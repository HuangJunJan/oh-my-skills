---
name: oms-review
description: >
  代码审查/PR review/diff review/方案 review/安全审查。关键词：审/review/PR/找问题/
  帮我看看/帮我看一下。叠加 $oms-meta + $oms-coding。纯审查任务不加载 coding 的领域 skill。
---

# OhMySkills 通用审查规范

本 skill 管"如何审查代码、diff、PR、方案和实现"。代码修改纪律见 `$oms-coding`，事实核验和工具边界见 `$oms-meta`，问答风格见 `$oms-qa`。

## Always Read
1. `rules/risk-levels.md` — 四级风险定级
2. `rules/output-format.md` — 输出格式与审查边界

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| PR / diff review | `references/review-checklist.md` | `workflows/review.md` |
| 安全审查 | `references/security-review.md` | `workflows/review.md` |
| 方案 review / 架构审查 | `references/review-checklist.md` | — |
| 性能审查 | `references/performance-review.md` | — |
| Other | `rules/risk-levels.md` | `workflows/review.md` |

## Known Gotchas
- 没读调用链就说"这里可能有问题" → 先读再判断
- 把所有建议标成严重问题 → 按 `rules/risk-levels.md` 定级
- 用"建议优化一下"代替具体影响和修法 → 给具体位置+影响+最小修法
- 为了凑数量列出无关 nit → 没实质问题就说"未发现需要阻塞的缺陷"
- 没验证就声称测试通过或风险已排除 → `$oms-meta/rules/evidence-integrity.md`

## Red Flags — STOP
- 发现自己在写"建议优化一下代码质量"（无具体位置）→ 停，定位到具体文件/行
- 发现 level 标签全是 "Major"（无 Blocker 无 Minor）→ 停，重新核实定级
- 审查结论没有明确说"可合并/需修/信息不足" → 停，补结论
