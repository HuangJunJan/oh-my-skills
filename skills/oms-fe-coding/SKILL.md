---
name: oms-fe-coding
description: 触发：前端代码改动 (.tsx/.ts/.jsx/.js/.vue/.svelte/.css/.scss/.html)；前端项目编码任务 (react/vue/svelte/next/nuxt/vite 等)。OhMySkills 前端领域规范：状态分层、接口契约、UI/a11y、性能、TypeScript、前端验证。叠加在 $oms-coding 之上。
---

# 前端编码规范 | Frontend Coding

本 skill 只补前端专属规则，通用执行纪律见 `$oms-coding`，元规则见 `$oms-meta`。冲突时本 skill 的前端细节优先。

## 1. 状态与数据流

- URL state（query/route params）、server state、form state、client UI state 分层管理。
- 能派生的数据不进 state；用 selector / `useMemo` / `computed` / store getter。
- 异步 UI 至少覆盖 loading、error、empty、success；不要只做 loading。
- 禁用 effect/watch 同步派生值或 prop -> state；能直接计算就直接计算。
- 跨组件共享状态必须有唯一事实源，避免双写和手动同步。

## 2. 请求与接口契约

- 以后端真实返回、OpenAPI/schema、mock server 或抓包结果为事实源；不要凭记忆写类型。
- 请求参数和响应显式类型化，禁 `any`；ID 在前端统一按 `string` 处理。
- 优先使用项目既有请求封装、SWR/TanStack Query/Vue Query/框架 load，不手写缓存、重试、竞态。
- 搜索、切 tab、分页、路由切换等会产生竞态的场景，用 AbortController、请求 ID 或框架能力丢弃过期响应。
- 鉴权过期、网络错误、业务错误码走统一拦截/封装，不在组件里散落重复 `try-catch`。

## 3. UI、样式与 a11y

- 复用设计系统和组件库；颜色、间距、字号、圆角、阴影、断点、暗色模式走 token。
- 不自造已有 Button/Input/Modal/Toast 等基础组件，除非任务就是建设组件库。
- 响应式布局必须设稳定尺寸/约束，避免文本溢出、布局抖动、元素重叠。
- 交互元素用语义标签：按钮用 `<button>`，链接用 `<a>`；键盘可达，有可见焦点。
- 图片按语义写 `alt`；表单 label/error/description 要正确关联。

## 4. 性能

- 默认不预优化；先实现正确行为，再用 profiler 或明确瓶颈决定 memo/虚拟化。
- 列表 key 必须稳定唯一，禁用 index 表示可增删/重排列表。
- 大列表使用虚拟滚动；不要一次渲染上百上千项。
- 避免 render 阶段创建昂贵对象、复杂计算或触发副作用。

## 5. TypeScript

- props、事件、API 类型从组件、schema 或生成类型推导；能 `import type` 就不手写第二份。
- 禁 `any`；不确定值用 `unknown` + 类型守卫。
- 工具类型优先于重复定义；复杂泛型以可读性为上限。

## 6. 前端验证

- 行为改动优先跑相关单测/组件测试、type-check、lint 或最小浏览器 smoke。
- UI 改动要检查桌面/移动关键断点；能截图或 Playwright 验证时优先使用。
- 数据流改动核对“用户操作 -> 请求参数 -> 响应映射 -> UI 呈现”。
- 无法启动前端环境时，说明缺失依赖/服务，并给人工复测路径。

## 反 anti-patterns

- ❌ `useEffect` / `watchEffect` 做派生计算。
- ❌ 手写 `fetch + useEffect` 重造请求缓存和竞态控制。
- ❌ 硬编码颜色/间距，不走 token。
- ❌ `<div onClick>` 代替 `<button>`。
- ❌ 用 `index` 当动态列表 key。
- ❌ 用 `any` 跳过接口类型。
