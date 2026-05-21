---
name: oms-meta
description: OhMySkills 最高优先级元规则集——优先级层级、Windows-UTF-8 基线、单一事实源、禁兼容旧逻辑、默认局部验证。触发：任何对话开始时优先加载；任何代码改动、新增、删除任务之前；任何 oms-* skill 触发之前。
---

# OhMySkills 元规则 | Meta Rules

本 skill 是 OhMySkills 的**最高优先级元规则集**，应优先于其它 `oms-*` skill 加载。任何 `oms-qa` / `oms-coding` / 未来新增 `oms-*` skill 与本 skill 冲突时，**以本 skill 为准**。

**优先级层级**（priority chain，从高到低）：

```
用户当次对话明确要求
  > 项目级 AGENTS.md（更近层级）
    > 本 oms-meta 元规则
      > 其它 oms-* skills 默认行为
        > 工具内置默认
```

冲突时取更高层级。

## 5 条元规则 | The Five Core Rules

1. **优先级层级**：用户当次对话明确要求 > 项目级 `AGENTS.md`（更近层级）> 本 `oms-meta` 元规则 > 其它 `oms-*` skills 默认行为 > 工具内置默认。冲突时取更高。

2. **平台基线**：Windows / PowerShell 读写文本必须显式使用 UTF-8 无 BOM。跨平台路径处理优先用语言内置 path API。

3. **单一事实源**：真实接口字段 / 代码 / 配置是唯一事实来源。不依赖印象、过时文档、缓存记忆。ID 类字段无论后端定义为何类型，前端统一 `string` 处理。

4. **禁止兼容旧逻辑**：除非用户明确要求，不兼容旧字段、历史分支、双轨口径，不额外做去重 / 判空兜底 / 重组映射等修正逻辑。

5. **默认局部验证**：默认只做改动涉及的文件夹 / 单文件验证，不做全量校验；仅当用户明确要求才执行全局校验（type-check / build / 全量 lint / 全量 test）。

## 反 anti-patterns

- ❌ 把本 skill 内容当成「可选建议」——这是元规则，不是风格偏好。
- ❌ 其它 `oms-*` skill 与本 skill 冲突时按其它 skill 走——必须以本 skill 为准。
- ❌ 「这次任务很小，可以跳过元规则」——元规则无论任务大小一律生效。
- ❌ 假定本 skill 已加载就跳过引用——冲突仲裁时仍需显式引用本 skill 的对应条目。
