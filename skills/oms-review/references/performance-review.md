# 性能审查清单 | Performance Review

`$oms-review` §3「性能与资源」的展开。逐项排查算法、数据库、内存资源、网络 IO、缓存、并发;每条给 坏例/好例 对照。多数性能修法属于 `$oms-be-coding` §2/§4 领域,这里只作审查时的判据与最小示例。

> 先测量再优化:把"可能慢"标为 Minor/建议,除非有明确瓶颈证据或属于热路径才提级。不要凭直觉把可读实现当缺陷。
> 示例语言只为说明问题形态,概念跨语言通用——对照本语言等价写法即可。

---

## 1. 算法复杂度

### O(n²) 查重(Java)

```java
// 坏例： O(n²):嵌套循环
boolean hasDup(int[] a) {
    for (int i = 0; i < a.length; i++)
        for (int j = i + 1; j < a.length; j++)
            if (a[i] == a[j]) return true;
    return false;
}

// 好例： O(n):集合一次遍历
boolean hasDup(int[] a) {
    Set<Integer> seen = new HashSet<>();
    for (int x : a) if (!seen.add(x)) return true;
    return false;
}
```

### 成员判断(TypeScript)

```typescript
// 坏例： 数组成员判断 O(n)
if (validIds.includes(userId)) { /* ... */ }   // validIds: number[]

// 好例： Set O(1)
const ids = new Set(validIds);
if (ids.has(userId)) { /* ... */ }
```

---

## 2. 数据库

### N+1 查询(TS / ORM)

```typescript
// 坏例： 懒加载在循环里触发 N 次查询
const users = await User.findAll();
for (const u of users) await u.getOrders();

// 好例： 关联预载,一次取回
const users = await User.findAll({ include: [Order] });
```

### SELECT * 与列裁剪(SQL)

```sql
-- 坏例： 取回 50 列只用 3 列
SELECT * FROM users WHERE status = 'active';

-- 好例： 只取需要的列
SELECT id, name, email FROM users WHERE status = 'active';
```

### 索引(SQL)

```sql
-- 坏例： WHERE 命中无索引列,全表扫描
SELECT * FROM orders WHERE user_id = 123 AND status = 'pending';

-- 好例： 复合索引(最常用/最有选择性的列在前)
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```

### 关联子查询 → JOIN(SQL)

```sql
-- 坏例： 相关子查询逐行执行
SELECT name,
       (SELECT COUNT(*) FROM orders WHERE user_id = u.id) AS cnt
FROM users u;

-- 好例： 一次 JOIN + 聚合
SELECT u.name, COUNT(o.id) AS cnt
FROM users u LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### 分页(Java / Spring Data)

```java
// 坏例： 全表载入内存
return repo.findAll().stream().map(this::toDto).toList();

// 好例： 按页取
Page<User> page = repo.findAll(PageRequest.of(p, size));
return page.map(this::toDto);
```

---

## 3. 内存与资源

### 资源未关闭(Java)

```java
// 坏例： 流未关闭,句柄泄漏
InputStream in = new FileInputStream(name);
return in.readAllBytes();

// 好例： try-with-resources 确保释放
try (InputStream in = new FileInputStream(name)) {
    return in.readAllBytes();
}
```

### 大数据流式处理(Go)

```go
// 坏例： 一次性读入超大文件
data, _ := os.ReadFile("big.csv")
for _, line := range strings.Split(string(data), "\n") { process(line) }

// 好例： 逐行扫描,内存恒定
f, _ := os.Open("big.csv")
defer f.Close()
sc := bufio.NewScanner(f)
for sc.Scan() { process(sc.Text()) }
```

### 连接池(Node / TS)

```typescript
// 坏例： 每次新建连接
for (const req of reqs) {
  const c = await createConnection();
  await c.query(req);
  await c.end();
}

// 好例： 池化复用
const pool = new Pool({ max: 10 });
for (const req of reqs) await pool.query(req);
```

---

## 4. 网络与 IO

### 阻塞 → 并发(TS)

```typescript
// 坏例： 顺序 await,N 个请求串行等待
const results = [];
for (const u of urls) results.push(await fetch(u).then(r => r.json()));

// 好例： 并发发起
const results = await Promise.all(urls.map(u => fetch(u).then(r => r.json())));
```

### 缺超时(Go)

```go
// 坏例： 无超时,可无限挂起
http.Get(url)

// 好例： 带超时的 context
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()
req, _ := http.NewRequestWithContext(ctx, "GET", url, nil)
http.DefaultClient.Do(req)
```

外部调用还应审查重试与退避、限流/熔断(见 `$oms-be-coding` §4),重试必须避免放大故障。

### 批量代替逐条(Python)

```python
# 坏例： 逐个 API 调用
for i in ids:
    api.get(f"/items/{i}")

# 好例： 批量端点
api.post("/items/batch", json={"ids": ids})
```

---

## 5. 缓存

### 记忆化(Python)

```python
# 坏例： 指数级重算
def fib(n):
    return n if n <= 1 else fib(n - 1) + fib(n - 2)

# 好例： 记忆化
@lru_cache(maxsize=None)
def fib(n):
    return n if n <= 1 else fib(n - 1) + fib(n - 2)
```

应用级缓存审查要点:缓存键是否唯一稳定、是否设过期、写操作是否同步失效相关缓存(避免脏数据)。

---

## 6. 前端专项(JavaScript)

```javascript
// 坏例： 重复 O(n) 查找
users.forEach(u => departments.find(d => d.id === u.deptId));

// 好例： 预建查找表 O(1)
const map = new Map(departments.map(d => [d.id, d]));
users.forEach(u => map.get(u.deptId));
```

前端还需审查:大列表是否虚拟滚动、列表 key 是否稳定唯一、render 阶段是否创建昂贵对象或触发副作用(见 `$oms-fe-coding` §4)。

---

## 速查

- [ ] 是否存在可避免的 O(n²) 及更差算法;成员判断是否用集合/Map
- [ ] 是否有 N+1;WHERE/JOIN 列是否有索引;是否 `SELECT *`;大结果集是否分页
- [ ] 文件/连接/流是否确保关闭;超大数据是否流式;连接是否池化
- [ ] I/O 是否并发;外部调用是否设超时、重试退避、限流熔断;能否批量
- [ ] 重复计算是否缓存;缓存键是否稳定、是否设过期、写时是否失效
- [ ] 前端大列表是否虚拟化、key 是否稳定、render 是否创建昂贵对象

> 性能问题给出可观测依据(复杂度、查询次数、热路径),不凭直觉。无法实测时按 `$oms-review` §5 说明这是静态判断及剩余不确定性。
