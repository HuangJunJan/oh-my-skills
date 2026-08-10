# Rule Deprecation 工作流

## Task Anchor（任务锚点）

**Goal:** 安全地废弃/删除/替换过时规则，防止文档膨胀，保持 skill 文件健康。

**Boundaries:**
- 不删除仍在使用的规则（除非有明确替代方案）
- 不一次性批量废弃大量规则（应逐条审查）
- 废弃后必须同步更新所有引用

**Done When:**
- 废弃的规则已从所有引用中移除
- DEPRECATED 标记的规则有明确到期日期
- 记入 CHANGELOG 或 git commit message 的 Deprecation Log

---

规则只增不减会导致文档膨胀。本 workflow 定义规则清退、废弃和自维护流程。

## 触发条件

- 扫描到过时规则（现有的描述不再准确）
- 技术栈迁移（相关技术已移除）
- 定期 drift 检查发现的问题
- 任务中出现"因为某条旧规则导致走了弯路"（AAR 扫描触发）

## 清退流程

### 第一步：分类

| 条件 | 动作 |
|------|------|
| 相关技术已移除 | 直接删除整条规则 |
| 正在迁移中 | 加 scope 标注（"仅适用于 legacy 模块"），保留 1 个迭代周期 |
| 不确定还有没有用 | 加 `<!-- DEPRECATED: reason, date -->` 注释，保留 1 个迭代周期 |
| 规则已过时但无替代 | 走"更新不改删" |

### 第二步：更新引用

删除/废弃规则后，同步检查：
- [ ] SKILL.md 的 Common Tasks 引用
- [ ] 所有 workflow 中的完成前检查项
- [ ] 其他 skill 的 `$oms-X` 引用
- [ ] 薄壳路由表
- [ ] 所有 `references/gotchas.md` 中的锚点引用

### 第三步：记录

把废弃决定记入 git commit message 或 CHANGELOG：

```markdown
- YYYY-MM-DD: 废弃了 `rules/xxx.md`，原因是 <原因>，替代方案是 <新规则位置>
```

## 自维护：评估式拆分

文件超标时回答三个问题：

1. 话题可分离？
2. 导航困难？
3. 拆后各部分能独立存在？

三个都 Yes → 拆。任何一个 No → 不拆。

## 自维护：评估式合并

碎片文件过多时：

1. 话题相关？
2. 合并后更好找？
3. 合并后不超标？

三个都 Yes → 合并。

## 定期 Drift 检查

每季度或重大模板更新后，用两个**真实不同类型**的项目跑同一套 Quick Start，`diff -r` 对比：

- `hooks/` 骨架文件应该几乎一样
- `rules/`、`SKILL.md` 的 Common Tasks、`gotchas.md` 应该完全不同
- 如果一样，说明模板越界了