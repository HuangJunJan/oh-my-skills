# 前端已知陷阱

本文件记录来自真实失败的教训。格式：标题、触发场景、根因、避免方式。禁止凭空编造。

---

# 状态陷阱

## effect-derived-state（effect 做派生）

**触发**：
```tsx
// ❌ 用 useEffect 同步派生值
const [fullName, setFullName] = useState('');
useEffect(() => { setFullName(first + ' ' + last); }, [first, last]);
```

**根因**：Agent 习惯"有变化就设 state"，但派生值不需要 state。

**避免**：
```tsx
// ✅ 直接计算
const fullName = `${first} ${last}`;
```

## dual-track-state（双轨状态）

**触发**：页面同时维护 `data`（接口原始）和 `displayData`（展示用），接口字段变更时只改了一边。

**根因**：Agent 为"适配 UI"创造中间 state，接口字段变化时忘记同步。

**避免**：接口返回只在边界做一次 normalize，页面直接消费。禁止"原始数据 + 展示数据"双轨。

# 接口陷阱

## field-drift（字段漂移）

**触发**：接口返回 `user_name`，回显用 `user_name`，但提交时改成 `userName`，口径不一致。接口文档升级后只搜 `user_name` 替换，漏了 `userName` 的那条提交路径。

**避免**：字段替换时搜索本次范围内所有出现位置；回显和提交使用同一字段口径。

## index-as-key

**触发**：`items.map((item, i) => <Item key={i} />)` — 可增删/重排列表用 index 做 key。

**根因**：Agent 默认用 index 省事。

**避免**：用稳定唯一 ID（如 `item.id`）。

---

<!-- 以下从真实失败中持续捕获 -->
