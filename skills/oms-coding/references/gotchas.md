# 编码已知陷阱

本文件记录来自真实失败的教训。格式：标题、触发场景、根因、避免方式。禁止凭空编造。

---

# 通用陷阱

## silent-fallback（静默兜底）

**典型触发**：
```java
// ❌ Agent 为"防止崩溃"加兜底
try { return riskyOperation(); }
catch (Exception e) { return defaultValue; } // 吞掉所有错误
```

```typescript
// ❌ Agent 为"兼容旧数据"加判空
const email = user.email || '';  // 掩盖了 email 确实缺失的问题
```

**根因**：Agent 在压力下倾向于"让代码看起来能跑"，而非"让失败可见"。

**避免**：失败必须通过异常/日志/返回值暴露；只有明确业务语义的默认值才能存在。

## mode-bloat（mode 堆砌）

**典型触发**：
```typescript
// ❌ 用 mode 参数分叉不同业务流程
function createOrder(mode: 'regular' | 'vip' | 'group') {
  if (mode === 'regular') { /* 30行 */ }
  else if (mode === 'vip') { /* 40行 */ }
  else { /* 50行 */ }
}
```

**根因**：Agent 复用已有函数作为"宿主"，加 flag 改变行为，逐步膨胀。

**避免**：不同业务 = 不同函数。用组合/策略模式只在真实需要时。

## scope-creep（范围蔓延）

**典型触发**：
```
用户："修一下空 email 导致的崩溃"
Agent：
  + 加了 docstring
  + "顺手"加强邮箱校验
  + "顺便"加了 username 长度校验（没被要求）
```

**根因**：Agent 在"让代码更好"的名义下越界。

**避免**：每一行改动都能直接追溯到用户的请求。检验：如果这行改动的 diff 被单独 review，能说出它修复了什么吗？

---

<!-- 以下从真实失败中持续捕获 -->
