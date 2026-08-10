# 安全审查清单 | Security Review

`$oms-review` SKILL.md Common Tasks「安全审查」的展开。逐项排查注入、认证授权、敏感数据、常见漏洞;每条给 坏例/好例 对照。命中后按 `rules/risk-levels.md` 定级(注入/越权/密钥泄露通常是 Blocker,缺校验/弱配置通常是 Major)。具体修复纪律见 `$oms-be-coding`。

> 示例语言只为说明问题形态,概念跨语言通用——审查时对照本语言的等价写法,不要因为示例不是当前语言就跳过。

---

## 1. 注入面

### SQL 注入(Java / JDBC)

```java
// 坏例： 字符串拼接不可信输入
stmt.executeQuery("SELECT * FROM users WHERE id = " + userId);

// 好例： 预编译参数化
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setLong(1, userId);
```

### 命令注入(Go)

```go
// 坏例： 拼接后交给 shell 解析
exec.Command("sh", "-c", "convert "+filename+" out.png").Run()

// 好例： 参数分离,不经过 shell
exec.Command("convert", filename, "out.png").Run()
```

### 路径穿越(Python)

```python
# 坏例： 直接拼用户路径,可被 ../ 逃逸
open(os.path.join(BASE_DIR, user_path))

# 好例： 规范化后确认仍在允许目录内
full = os.path.realpath(os.path.join(BASE_DIR, user_path))
if not full.startswith(os.path.realpath(BASE_DIR) + os.sep):
    raise ValueError("path traversal")
```

### 模板注入 / 代码执行(JavaScript)

```javascript
// 坏例： 用户输入进 eval / 动态执行
eval(userExpr);
new Function(userCode)();

// 好例： 不对输入求值;需要表达式时用白名单解析器
const result = evalWithAllowlist(userExpr, allowedVars);
```

### 不安全反序列化(Java)

```java
// 坏例： 反序列化不可信字节,可触发任意代码
Object o = new ObjectInputStream(request.getInputStream()).readObject();

// 好例： 用数据格式(JSON)+ 固定目标类型,不还原任意对象图
MyDto dto = objectMapper.readValue(request.getInputStream(), MyDto.class);
```

---

## 2. 认证与授权

### 鉴权缺失(Node / TS)

```typescript
// 坏例： 受保护资源没有 authn
app.get("/admin/users", (req, res) => res.json(listUsers()));

// 好例： 统一 middleware/guard 校验
app.get("/admin/users", requireAuth, (req, res) => res.json(listUsers()));
```

### 越权访问 IDOR(Go / Gin)

```go
// 坏例： 只验登录,不验归属:任何登录用户都能看别人订单
r.GET("/orders/:id", requireAuth, func(c *gin.Context) {
    c.JSON(200, getOrder(c.Param("id")))
})

// 好例： 校验资源属于当前用户
r.GET("/orders/:id", requireAuth, func(c *gin.Context) {
    order := getOrder(c.Param("id"))
    if order.UserID != currentUser(c).ID {
        c.AbortWithStatus(403)
        return
    }
    c.JSON(200, order)
})
```

审查要点:把 authz 判断散落在 handler 里、或只判 authn 不判 authz,都要标出;优先 middleware/guard/interceptor 分层(见 `$oms-be-coding/rules/api-contract.md`)。

### 会话与 CSRF(Node / TS)

```typescript
// 坏例： 改状态的接口无 CSRF 防护、cookie 无 SameSite
app.post("/transfer", (req, res) => doTransfer(req.body));

// 好例： CSRF token + SameSite cookie
app.post("/transfer", csrfProtection, (req, res) => doTransfer(req.body));
res.cookie("sid", sid, { httpOnly: true, secure: true, sameSite: "lax" });
```

---

## 3. 敏感数据

### 硬编码密钥(Go)

```go
// 坏例： 凭证写死在代码
const apiKey = "sk-live-9f8c..."

// 好例： 从环境变量 / 密管读取
apiKey := os.Getenv("API_KEY")
```

### 日志 / 错误信息泄露(Python)

```python
# 坏例： 把密码、token、栈细节直接写日志或返回给前端
logger.info(f"login payload: {request.json}")
return {"error": str(exc), "trace": traceback.format_exc()}

# 好例： 脱敏 + 对外只给通用错误,细节进内部日志
logger.info("login attempt", extra={"user": mask(email)})
return {"error": "invalid credentials"}, 401
```

### 口令哈希与传输(Java)

```java
// 坏例： 弱哈希存口令
String hash = DigestUtils.md5Hex(password);

// 好例： 专用密码哈希
String hash = new BCryptPasswordEncoder().encode(password);
```

审查要点:敏感字段(token、身份证、手机号、银行卡)是否脱敏;传输是否强制 TLS;静态是否加密(见 `$oms-be-coding/rules/security-config.md`)。

---

## 4. 其他常见漏洞

### SSRF(Go)

```go
// 坏例： 用用户提供的 URL 直接发请求,可打内网
http.Get(c.Query("url"))

// 好例： 解析后拒绝内网/回环地址,按白名单放行
host := hostOf(rawURL)
if isPrivateIP(resolve(host)) {
    return errors.New("blocked host")
}
```

### XXE(Java)

```java
// 坏例： 解析 XML 时启用外部实体
DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(input);

// 好例： 关闭 DTD / 外部实体
DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
f.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
f.newDocumentBuilder().parse(input);
```

### CORS / 安全响应头(Node / TS)

```typescript
// 坏例： 通配 + 携带凭证,等于对全网开放
res.header("Access-Control-Allow-Origin", "*");
res.header("Access-Control-Allow-Credentials", "true");

// 好例： 按白名单回显来源
if (allowedOrigins.includes(req.headers.origin))
  res.header("Access-Control-Allow-Origin", req.headers.origin);
```

---

## 速查

- [ ] 不可信输入是否直接进 SQL / 命令 / 路径 / 模板 / 反序列化
- [ ] 受保护端点是否都有 authn,资源访问是否校验 authz(不止登录)
- [ ] 改状态接口是否有 CSRF 防护;cookie 是否 httpOnly/secure/SameSite
- [ ] 是否硬编码密钥/凭证;敏感数据是否在日志、错误、配置里泄露
- [ ] 口令是否用 bcrypt/argon2/scrypt;传输是否强制 TLS
- [ ] 用户提供的 URL 是否防 SSRF;XML 是否关外部实体;CORS 是否白名单

> 不能验证的项(缺乏运行环境、缺少调用链)按 `rules/output-format.md` §审查边界 说明剩余风险,不输出假确定结论。
