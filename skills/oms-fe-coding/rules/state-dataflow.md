# 状态与数据流

## 状态分层
URL state（query/route params）、server state、form state、client UI state 分层管理。
能派生的数据不进 state；用 selector / `useMemo` / `computed` / store getter。
检验：这个 state 变量的值能否从其它 state 直接算出来？— 能就改派生。

## 异步 UI 四态
loading、error、empty、success 至少覆盖；不要只做 loading。

## 禁止 effect/watch 同步派生
禁用 effect/watch 同步派生值或 prop → state；能直接计算就直接计算。

## 唯一事实源
跨组件共享状态必须有唯一事实源，避免双写和手动同步。

## 页面 state 原则
页面 state 表达页面真实消费方式和组件原生值模型；不要为接口字段、旧 state、mock 口径维护等价双轨状态。

## 列表/详情数据流
列表/详情展示优先承接真实接口 records/detail；编辑态可转成适合组件的结构，但只在接口边界集中转换。
