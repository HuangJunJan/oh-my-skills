---
name: oms-fe-coding
description: 前端通用编码规范层——React/Vue/Svelte 状态与数据流、数据获取、样式与设计系统、渲染性能、可访问性 a11y、TS 在前端。叠加在 $oms-coding 之上。触发：前端代码改动(.tsx/.ts/.jsx/.js/.vue/.svelte/.css/.scss/.html)；前端项目编码任务(package.json 含 react/vue/svelte/next/nuxt/vite 等)。
---

# 前端通用编码规范 | Frontend Coding Conventions

本 skill 是 OhMySkills 的**前端领域层**，叠加在 `$oms-coding`（跨语言通用编码层）之上。仅承载前端（浏览器 / SSR 框架）专属规则；跨语言通用规则（复用 / 命名 / 最小改动 / 交付报告等）见 `$oms-coding`。冲突时本 skill 优先。元层规则（优先级 / 平台基线 / 工具能力 / 不确定不假设 / skill 间引用）见 `$oms-meta`。

## A. 状态与数据流 | State and Data Flow

- **状态分层**（state stratification）：URL state（query / route params）/ server state（远端数据，归 SWR/Query 等）/ form state（受控表单输入）/ client state（UI 临时态如 modal open）各管各的层。例：分页码 / 筛选条件放 URL 不放 React state，刷新可还原、可分享。
- **派生数据不存 state**：能从已有数据计算的值用 selector / `useMemo` / Vue `computed`，禁存进 state。例：「已完成 todo 数」从 `todos.filter(...)` 算，不维护独立 `completedCount`。
- **异步状态四态**：`idle` / `loading` / `success` / `error` 全覆盖。禁只处理 `loading`，遗漏 `error` 边界 / `empty` 展示。
- **effect 反 anti-patterns**：禁在 `useEffect` / `watchEffect` 里做派生计算、链式 effect、用 effect 同步 prop → state。能直接 derived 就 derived，不绕 effect。

## B. 数据获取与请求 | Data Fetching

- **优先成熟方案**：React 用 SWR / TanStack Query；Vue 用 Pinia Colada / Vue Query；Svelte 用 SvelteKit `load` / TanStack Query。禁手写 `useEffect + fetch` 重新发明缓存 / 重试 / 竞态处理。
- **接口字段为唯一事实源**（single source of truth）：以后端真实返回为唯一事实源，不依赖印象、过时文档、缓存记忆。先看接口实际响应再写类型。
- **ID 字段统一 `string`**：无论后端定义为何类型（int / long / uuid），前端 / 调用方统一 `string` 处理，避免精度丢失与隐式转换。
- **类型显式**：请求参数 + 响应类型必须标注，禁 `any`。
- **竞态防护**（race condition）：用 `AbortController` 或请求 ID，丢弃过期响应。搜索 / 切 tab / 翻页等场景必做。
- **错误统一拦截**：axios `interceptor` / `fetch` wrapper 集中处理鉴权过期、网络错误、业务错误码；禁组件内散落 `try-catch`。

## C. 样式与设计系统 | Styling and Design System

- **设计 token 优先**：颜色 / 间距 / 字号 / 阴影 / 圆角 / 动效时长全走 token（CSS var / Tailwind config / `theme.ts`）。禁硬编码 `#1890ff` / `padding: 16px` / `border-radius: 4px`。
- **复用组件库**：antd / MUI / shadcn / Element Plus / Naive UI 等的基础组件（Button / Input / Modal / Toast）直接用，禁自造「我们自己的 Button」造轮子。
- **className 单一惯例**：项目内只用一种风格——Tailwind utility-first / CSS Modules / styled-components / BEM 任选其一，不混用。
- **响应式 / 暗色模式走 token**：断点用 token（`breakpoint.md` / Tailwind `screens`），暗色模式用 CSS 变量切换或 token theme。禁散写 `@media (max-width: 768px)` 与 `if (isDark) color = '#fff'`。

## D. 组件与渲染性能 | Rendering Performance

- **默认不优化**：先把功能跑通再 profile。用 React DevTools Profiler / Vue Devtools / Svelte Devtools 定位热点，禁拍脑袋包 `useMemo`。
- **`key` 稳定唯一**：列表 `key` 必须用 `item.id` 等稳定值，禁 `index`（除非列表纯静态不增删不重排）。
- **手动 memo 不默认**：`useMemo` / `useCallback` / Vue `computed` 仅在 profile 出明确收益时加，禁默认包裹每个函数 / 对象。过度 memo 反而损耗。
- **大列表虚拟化**：> 100 项的列表用 react-window / vue-virtual-scroller / svelte-virtual 等虚拟化方案，禁全量渲染。

## E. 可访问性 | Accessibility (a11y)

- **语义化 HTML**：`<button>` 不写成 `<div onClick>`，`<a>` 不写成 `<span>`，`<nav>` / `<main>` / `<article>` 用对，让屏幕阅读器与键盘用户能正确解析。
- **键盘可达**：所有交互元素 Tab 可达 + Enter / Space 触发 + 可见焦点环（禁 `outline: none` 不补 `:focus-visible`）。
- **图片 `alt`**：内容图必有 `alt`；纯装饰图 `alt=""`（不要省略属性）。
- **表单关联**：`<label for="x">` 关联 `<input id="x">`；错误信息走 `aria-describedby` 关联到字段，让屏幕阅读器在聚焦时朗读。

## F. TypeScript 在前端 | TypeScript in Frontend

- **props 类型从源头推导**：React 用 `ComponentProps<typeof X>` / `React.ComponentPropsWithoutRef<'button'>`；Vue 用 `defineProps<T>()`；从 OpenAPI / schema 生成的类型直接 `import type`，禁手写一遍。
- **禁 `any`**：必要时用 `unknown` + 类型守卫（`typeof` / `in` / 自定义谓词）。
- **工具类型优先**：`Pick` / `Omit` / `Partial` / `Required` / `ReturnType` / `Awaited` 优先于手写重定义。
- **类型可读性优于表达力**：见 `$oms-coding` B 节「不做类型 / 泛型炫技」。

## 反 anti-patterns

- ❌ 用 `useEffect` 监听 prop 变化把派生值塞进 state（应直接派生 / `useMemo`）
- ❌ 手写 `useEffect + fetch` 重新发明 SWR / TanStack Query 的缓存与竞态
- ❌ 硬编码 `#1890ff` / `padding: 16px` 不走设计 token
- ❌ 列表用数组下标作 key（`item.id` 才稳定）
- ❌ `<div onClick>` 替代 `<button>`（失去键盘可达 + 屏幕阅读器语义）
- ❌ props 类型手写一遍而不从 API schema / `ComponentProps` 推导
- ❌ 用 `any` 跳过类型，该用 `unknown` + 守卫
- ❌ 暗色模式靠 `if (isDark)` 散落判断而非 CSS 变量 / token theme
- ❌ 默认给每个函数包 `useCallback` / 每个对象包 `useMemo`（profile 出热点再加）
- ❌ 分页 / 筛选状态存 React state 不进 URL（刷新即丢失，无法分享链接）
