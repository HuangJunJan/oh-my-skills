# Add Page / Component 工作流

## Task Anchor（任务锚点）

**Goal:** 按需求新增页面或组件，状态分层、数据流正确、UI 四态完整。

**Boundaries:**
- 复用设计系统组件，不自造基础组件
- 不手写 fetch + useEffect
- 不引入新状态管理库，除非项目已有

**Done When:**
- 页面路由和状态来源确定
- 异步 UI 四态（loading/error/empty/success）覆盖
- 列表 key 稳定唯一
- 无线程/竞态问题
- AAR 扫描完成

---

## Step 1 — 确认设计
- 页面路由、状态来源（URL param / query / server state）
- 读 `rules/state-dataflow.md`

## Step 2 — 实现
- 读 `rules/ui-a11y.md` — 组件、a11y、性能
- 复用设计系统组件，不自造 Button/Input/Modal
- 列表 key 稳定唯一
- 异步 UI 四态：loading / error / empty / success

## Step 3 — 数据接线（如有）
- 读 `rules/api-integration.md`
- 接口入参/出参类型化
- 边界转换集中处理

## Step 4 — 验证
- 读 `rules/verification.md`
- type-check + lint + 浏览器 smoke
- 检查桌面/移动关键断点

## Step 5 — 交付
- 走 `$oms-meta/workflows/task-closure.md` AAR

### Gotcha 检查
- [ ] 没有 useEffect/watch 做派生计算
- [ ] 没有 index 当动态列表 key
- [ ] 没有 div onClick 代替 button
- [ ] 没有 any 类型在接口/组件 props 里
- [ ] 本次产生的孤儿代码已清理