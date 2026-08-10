# Skill 分层维护

- 跨 skill 共用规则只保留在一个最合适的位置，其它 skill 用 `$oms-X` 引用。
- Skill 内容保持精简；只写会改变 agent 行为的规则。
- `description` 必须写清触发场景；正文只写触发后的执行规则。
- 领域 skill 只写领域差异，不复制 `$oms-coding` 的通用纪律。
- 修改 skill 时同步检查 README 技能表、示例触发、安装说明和相关 agent 元数据。

检验：修改规则后自问"这条规则在其它 skill 里有副本需要同步删除吗？"
