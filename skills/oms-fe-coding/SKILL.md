---
name: oms-fe-coding
description: 触发：前端代码改动 (.tsx/.ts/.jsx/.js/.vue/.svelte/.css/.scss/.html)；前端项目编码任务 (react/vue/svelte/next/nuxt/vite 等)；前端页面对接真实接口、字段替换、数据回显、提交参数、列表/详情/表单落地、mock 替换真实接口、按接口契约或联调证据调整页面。OhMySkills 前端领域规范：状态分层、真实数据源驱动、接口契约、UI/a11y、性能、TypeScript、前端验证。叠加在 $oms-coding 之上。
---

# 前端编码规范 | Frontend Coding

本 skill 只补前端专属规则，通用执行纪律见 `$oms-coding`，元规则见 `$oms-meta`。冲突时本 skill 的前端细节优先。

## 1. 状态与数据流

- URL state（query/route params）、server state、form state、client UI state 分层管理。
- 能派生的数据不进 state；用 selector / `useMemo` / `computed` / store getter。
- 异步 UI 至少覆盖 loading、error、empty、success；不要只做 loading。
- 禁用 effect/watch 同步派生值或 prop -> state；能直接计算就直接计算。
- 跨组件共享状态必须有唯一事实源，避免双写和手动同步。
- 页面 state 表达页面真实消费方式和组件原生值模型；不要为接口字段、旧 state、mock 口径维护等价双轨状态。
- 列表/详情展示优先承接真实接口 records/detail；编辑态可转成适合组件的结构，但只在接口边界集中转换。

## 2. 请求与接口契约

- 真实数据源优先级：用户提供或项目可获取的接口资料、接口契约、联调证据 > 项目真实 API 模块和后端返回结构 > 已联调页面调用链；mock、旧实现、历史字段仅作线索。
- 数据接线先确认接口入参、出参、字段名、字段类型、字段语义，再定位页面消费点（展示、筛选、编辑、校验、提交、刷新）。
- 请求参数和响应显式类型化，禁 `any`；ID 类型以后端契约为准，涉及长整型、展示、路由参数、表单值时前端优先按 `string` 处理，避免精度丢失和隐式转换。
- 只在边界做必要转换：接口返回 -> `normalize`/`convert` -> 页面 state；页面 state -> `serialize`/`buildPayload` -> 接口参数。转换函数命名要表达方向。
- 回显和提交必须使用同一字段口径；接口字段变化时同步修改类型、默认值、回显、提交、校验和刷新链路。
- 字段替换后搜索并清理本次范围内的旧字段、旧映射、mock 口径、旧 TS 类型和双轨状态。
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
- 数据流改动核对“请求参数 -> 接口返回 -> 边界转换 -> 页面 state -> 展示/编辑 -> 提交转换 -> 接口参数”。
- 接口字段或数据结构变更后，交付前确认真实接口字段已核对、回显链路完整、提交参数符合契约、无本次范围内旧字段兼容或静默兜底。
- 无法启动前端环境时，说明缺失依赖/服务，并给人工复测路径。

## 反 anti-patterns

- 避免：`useEffect` / `watchEffect` 做派生计算。
- 避免：手写 `fetch + useEffect` 重造请求缓存和竞态控制。
- 避免：沿用旧页面结构、mock 字段或历史 state 决定真实接口落地。
- 避免：为兼容旧字段保留新旧双字段、散落映射或静默兜底。
- 避免：回显和提交使用不同口径，只修报错点不核对完整数据链路。
- 避免：硬编码颜色/间距，不走 token。
- 避免：`<div onClick>` 代替 `<button>`。
- 避免：用 `index` 当动态列表 key。
- 避免：用 `any` 跳过接口类型。
