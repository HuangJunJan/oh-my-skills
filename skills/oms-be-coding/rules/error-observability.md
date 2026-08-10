# 错误与可观测性

## 错误分类
区分 domain error、infra error、unexpected error；不同类别对应不同处理策略。

## 错误处理铁律
捕获错误必须 log、wrap、return 或 rethrow；禁止空 catch、`except: pass`、忽略 err。
检验：catch 块里有没有"什么都不做"的分支？

## 日志规范
- 日志结构化，包含 request/trace/user/service 等上下文。
- 不用裸 `print` / `console.log` 代替日志。

## 可观测性
新接口或关键路径同步考虑指标、trace、错误率和延迟观测。

## 失败策略
失败要 fail fast 或显式降级；不要僵死、假成功或静默丢任务。
