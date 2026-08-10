---
name: oms-fe-coding
description: >
  前端代码改动 (.tsx/.ts/.jsx/.js/.vue/.svelte/.css/.scss/.html)；前端项目
  (react/vue/svelte/next/nuxt/vite)；接口对接/mock 替换/字段替换/数据回显。
  关键词：页面/组件/hook/样式/接口对接/mock/回显/field/modal。需配合 $oms-coding + $oms-meta。
  仅当任务涉及前端编码时加载。
---

# OhMySkills 前端编码规范

本 skill 只补前端专属规则，通用执行纪律见 `$oms-coding`，元规则见 `$oms-meta`。
冲突时本 skill 的前端细节优先。

## Always Read
1. `rules/state-dataflow.md` — 状态与数据流
2. `rules/api-integration.md` — 接口对接与类型

## Session Discipline
每个新任务——同一会话的第 N 轮——必须重读本 SKILL.md。
检验：这次读的文件和 Common Tasks 里对应路由列的完全一致吗？

## Common Tasks
| 任务 | 必读 | 流程 |
|------|------|------|
| 新增页面/组件 | `rules/ui-a11y.md` | `workflows/add-page.md` |
| 接口对接 / mock 替换 | `rules/api-integration.md` | `workflows/integrate-api.md` |
| 字段替换 / 回显修正 | `rules/api-integration.md` | `workflows/integrate-api.md` |
| Fix bug（前端） | `$oms-coding` rules + `rules/state-dataflow.md` | `$oms-coding/workflows/fix-bug.md` |
| 样式 / 布局 | `rules/ui-a11y.md` | — |
| Other | `rules/state-dataflow.md` + `rules/api-integration.md` | 按最接近的 workflow |

## Known Gotchas
- `useEffect` / `watchEffect` 做派生计算 → 用 computed / selector / useMemo
- 手写 `fetch + useEffect` → 用 SWR / TanStack Query / Vue Query / 框架 load
- 回显和提交使用不同字段口径 → `rules/api-integration.md`
- 用 `index` 当动态列表 key → 用稳定唯一 ID
- `<div onClick>` 代替 `<button>` → 用语义标签
- 用 `any` 跳过接口类型 → 用 `unknown` + 类型守卫
- 保留旧字段兼容 → 接口字段变化时同步清理旧字段/旧映射/mock 口径/旧类型

## Red Flags — STOP
- "先用 mock 数据，后面再换" → 停，直接对接真实接口契约
- "这个 useEffect 先放着，以后再优化" → 停，能直接计算就直接计算
- "加个 any 先跑通再说" → 停，用 `unknown` + 类型守卫
