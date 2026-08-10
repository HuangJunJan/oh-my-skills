# Subagent-Driven Development 工作流

## Task Anchor（任务锚点）

**Goal:** 将独立子任务派发给干净上下文的 worker，主 Agent 只做计划和 review，保持上下文纯净。

**Boundaries:**
- 不满足启用条件时直接内联做，不派发
- worker 不能再开 worker（禁止递归派发）
- 不在主上下文补 worker 没做完的 10%

**Done When:**
- 所有 worker 产物通过两阶段 review
- 主 Agent 上下文未污染
- 无 drive-by 改动
- AAR 扫描完成

---

启用条件（满足任意一条）：
- 子任务 ≥ 3 个且互相独立
- 单任务会吃掉 > 30% 剩余 context
- 任务是"探索 + 实现 + review"混合形态
- 即将多小时自动运行

都不满足时直接内联做。

## 四阶段流程

### Phase 1 — Plan（写合约清单）

分析用户需求，拆成独立子任务。每个子任务是一条合约：

```markdown
## Goal
<一句话，面向结果>

## Inputs
<worker 允许读的确切文件/目录>

## Outputs
<worker 必须产出/修改的确切文件>

## Forbidden Zones
<不许碰的文件/目录/副作用；不确定默认禁>

## Acceptance Criteria
<可机械验证的命令，如 `yarn tsc --noEmit`>
```

规则：
- 任何字段不能空
- Goal 面向结果，不微管步骤
- Acceptance 必须是可执行检查，不是散文
- 有依赖的任务在前，无依赖的并行

### Phase 2 — Dispatch（派发）

每份合约开一个干净 worker，合约原文作 prompt，不带主对话历史。

- 无依赖就并行派发
- 禁止递归派发（worker 不能再开 worker）
- 禁止中途往 worker 上下文塞"澄清"——合约错了就取消重写

### Phase 3 — Two-Stage Review

**Stage A — 合规检查：**
- [ ] Outputs 文件是否都产生了/修改了
- [ ] 没有碰 Forbidden Zones 里的文件
- [ ] Acceptance Criteria 全部通过
- [ ] 没有 drive-by 改动（无关格式化、重命名、重构）

**Stage B — 质量检查：**
- [ ] 代码质量符合 `$oms-coding/rules/code-quality.md`
- [ ] 没有静默兜底、mode 堆砌、范围蔓延
- [ ] 没有遗落孤儿代码
- [ ] 可以通过 AAR 扫描（见 task-closure.md）

两个 stage 都过才 merge。Stage A 不过直接重派更紧的合约，**不在主上下文里内联补**。

### Phase 4 — Merge 或 Reject

- 所有 worker 产物经 review 后合并
- 走 `workflows/task-closure.md` AAR

### 禁止项

- 递归派发（worker 不能再开 worker）
- 让 worker review 自己的产物
- 中途往 worker 上下文塞"澄清"
- 跳过 Stage A 只跑 Stage B，或反之
- "worker 基本对了，剩下 10% 我在主上下文补"——这是最常见的污染主上下文的动作，重派更紧的合约

### Harness 兼容性

只有 **Claude Code** 有原生 `Task` 工具。Cursor / Codex / Gemini / Copilot 降级处理：
- 在单上下文里按 checklist 模拟
- 或每个子任务手动开新会话
- 降级模式仍然保留两阶段 review + 合约检查