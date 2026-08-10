# Integrate API 工作流

适用于：mock 替换为真实接口、接口字段变更后的回显/提交修正、新增接口对接。

## Task Anchor（任务锚点）

**Goal:** 将接口数据源从 mock/旧字段切换到真实接口，确保全链路数据流正确。

**Boundaries:**
- 不修改接口契约本身
- 不保留新旧双轨状态
- 不保留旧字段兼容层

**Done When:**
- 请求参数和响应已类型化，无 any
- 回显和提交字段口径一致
- 旧 mock 数据/类型/字段已清理
- 竞态场景有防护
- AAR 扫描完成

---

## Step 1 — 确认契约
- 读 `rules/api-integration.md`
- 接口资料/契约/类型：入参、出参、字段名、字段类型、字段语义
- 确认数据源优先级：契约 > 既有真实调用 > mock/旧实现

## Step 2 — 定位页面消费点
- 展示字段
- 筛选/搜索参数
- 编辑/表单字段
- 校验规则
- 提交参数
- 刷新/分页

## Step 3 — 写数据接线
- 接口返回 → normalize → 页面 state
- 页面 state → buildPayload → 接口参数
- 转换函数命名表达方向

## Step 4 — 清理旧代码
- 搜索并删除：旧字段、旧映射、mock 口径、旧 TS 类型、双轨状态
- 确认回显和提交使用同一字段口径

## Step 5 — 验证
- 数据流全链路核对：请求参数 → 接口返回 → 边界转换 → 页面 state → 展示/编辑 → 提交
- 读 `rules/verification.md`

## Step 6 — 交付
- 走 `$oms-meta/workflows/task-closure.md` AAR

### Gotcha 检查
- [ ] 回显和提交字段口径一致
- [ ] 旧 mock 数据/类型/字段已清理
- [ ] 没有保留新旧双字段兼容
- [ ] 请求参数和响应已类型化，无 any
- [ ] 竞态场景有 AbortController 或框架能力防护