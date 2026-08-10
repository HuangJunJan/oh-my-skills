# Add Feature 工作流

## Task Anchor（任务锚点）

**Goal:** 按需求实现功能，最小方案，复用优先。

**Boundaries:**
- 只做需求覆盖范围内的改动
- 不新增依赖，除非确有必要
- 不顺手整理/重构未涉及的代码
- 不影响既有契约和行为

**Done When:**
- 功能满足验收标准
- 测试/type-check/lint 通过
- 契约未被破坏（或已同步更新）
- AAR 扫描完成

---

## Step 1 — 确认目标与边界
- 功能范围、成功标准、不做什么
- 涉及的文件/模块/接口
- 读项目既有契约和相邻实现

## Step 2 — 设计最小方案
- 复用优先：查已有函数/hook/middleware/schema/类型/组件
- 不新增依赖，除非确有必要
- 契约优先：API 结构、类型定义、数据流先定

## Step 3 — 实现
- 读 `rules/code-quality.md` — 命名/函数/类型/注释/安全
- 读 `rules/sensitive.md` — 不碰用户已有改动、不主动删除
- 局部改动：只改需求覆盖范围

## Step 4 — 验证
- 读 `rules/verification.md`
- 跑相关测试/type-check/lint
- UI 改动：检查关键断点
- 接口改动：核对"上游输入 → 契约 → 下游消费"

## Step 5 — 交付
- 读 `rules/code-quality.md` 的交付前自检
- 写交付报告
- 走 `../oms-meta/workflows/task-closure.md` AAR

### 完成前 Gotcha 检查
- [ ] 没有新建已有函数/类型/组件的替代品
- [ ] 没有 mode 堆砌
- [ ] 没有硬编码密钥/生产地址
- [ ] 生成的/lockfile 变更能追溯到源改动
- [ ] 本次产生的孤儿代码已清理