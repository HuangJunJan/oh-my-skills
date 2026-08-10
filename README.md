# OhMySkills

> **跨 AI 编程工具通用的 Skills 仓库。** 路由驱动的编码、问答、审查规范，一次维护、按需安装。

---

## 是什么

让 AI agent 在编码时自动遵循规范，不是靠每次复制的 AGENTS.md，而是靠一个**路由驱动的 skill 体系**：

- **SKILL.md 是路由中心**，不是百科全书——Agent 按 Common Tasks 表格自动找到对应 rules/workflows
- **薄壳（thin shell）** 保证上下文压缩后路由表仍然存活
- **Task Closure Protocol (AAR)** 让 skill 随项目自动进化，每次任务结束扫描新陷阱/新模式
- **Known Gotchas + Red Flags** 在任务路径上拦截已知错误，不只在 references 里沉睡

本仓库自身**不写任何安装脚本**，全部交给 `vercel-labs/skills` 处理。

---

## 快速上手

```bash
# 装到当前项目，自动适配所有已用的 AI 工具
npx skills add HuangJunJan/oh-my-skills --all
```

**装完后建议加固薄壳：** 复制 `shells/` 下对应文件到项目根目录，让路由表在长会话中不丢失。

```bash
cp shells/AGENTS.md ./AGENTS.md      # 通用 agent
cp shells/CLAUDE.md ./CLAUDE.md      # Claude Code
cp shells/CODEX.md ./CODEX.md        # Codex CLI
```

---

## 提供的 Skills

| Skill | 主题 | 何时生效 |
|---|---|---|
| `oms-meta` | 共用元规则：指令层级、事实核验、工具边界、平台适配、skill 分层维护 | 任一 `oms-*` 生效时共同加载 |
| `oms-qa` | 问答交互：中文默认、先结论、需求收敛、盘问/严审模式 | 对话/需求讨论/盘问模式 |
| `oms-coding` | 通用编码：调试优先、根因修复、代码质量、敏感边界、验证与交付 | 任何代码改动/新增/删除/验证/交付 |
| `oms-be-coding` | 后端规范：API 契约、数据层、错误可观测性、并发韧性、安全配置 | 后端代码/项目编码任务 |
| `oms-fe-coding` | 前端规范：状态分层、接口接线、UI/a11y、性能、TypeScript | 前端代码/接口对接/mock 替换 |
| `oms-review` | 审查规范：风险分级、安全/性能/测试/兼容/依赖逐项排查 | 代码审查/PR review/安全审查 |

每个 skill 的 SKILL.md 都是**路由中心**（≤60 行），包含 Always Read、Common Tasks 路由表、Known Gotchas 和 Red Flags STOP 块。详细规则在 `rules/`、流程在 `workflows/`、陷阱在 `references/gotchas.md`。

---

## 目录结构

```
skills/oms-*/
├── SKILL.md              ← 路由中心（Always Read + Common Tasks + Known Gotchas + Red Flags）
├── rules/                ← 长期约束（按主题分文件）
├── workflows/            ← 任务流程（含 Task Anchor 锚点 + AAR 闭环）
├── references/           ← 背景资料（gotchas.md、审查清单等）
│   └── gotchas.md        ← 已知陷阱（只从真实失败捕获，禁止凭空编造）
└── scripts/              ← 可选：自检脚本

shells/                    ← 薄壳模板（AGENTS.md / CLAUDE.md / CODEX.md / GEMINI.md）
hooks/                     ← 可选：SessionStart + PreToolUse 双钩子（见安装说明）
scripts/
  └── smoke-test.sh        ← 全量结构完整性自检
```

---

## 安装

底层全部走 `npx skills`。常用命令矩阵：

```bash
# 一行装（推荐）：自动检测已装 agent，装到当前项目
npx skills add HuangJunJan/oh-my-skills

# 装全部 skill 到全部已检测到的 agent，不交互
npx skills add HuangJunJan/oh-my-skills --all

# 指定 agent
npx skills add HuangJunJan/oh-my-skills -a claude-code

# 指定 skill
npx skills add HuangJunJan/oh-my-skills -s oms-coding

# 全局安装
npx skills add HuangJunJan/oh-my-skills -g

# 版本钉
npx skills add HuangJunJan/oh-my-skills@<tag>
```

---

## 使用

装完即用。Agent 按 SKILL.md 的 description 关键词自动匹配，按 Common Tasks 路由表加载对应规则。

### 指令层级

```
用户当次明确要求
  > 项目规则（AGENTS.md / CLAUDE.md）
    > oms-meta（共用基线）
      > 其它 oms-* skills
        > 工具默认行为
```

### 任务闭环

每个非琐碎任务结束前，Agent 会走 Task Closure Protocol（`oms-meta/workflows/task-closure.md`），30 秒 AAR 扫描发现的新陷阱/新模式，通过 2/3 录入标准后自动记录到 `references/gotchas.md`。

### 常见任务触发

| 用户说 | 触发 skill | 路由 |
|---|---|---|
| "修一下这个空指针" | `oms-coding` | Common Tasks → Fix bug |
| "加一个新接口" | `oms-coding` + `oms-be-coding` | Add API workflow |
| "把 mock 换成真实接口" | `oms-coding` + `oms-fe-coding` | Integrate API workflow |
| "帮我 review 这个 PR" | `oms-review` | Review workflow |
| "盘问我的方案" | `oms-qa` | 盘问/严审模式 |

---

## 更新

```bash
npx skills update          # 更新所有已装 skill
npx skills update oms-coding  # 只更新某一个
```

---

## 卸载

```bash
npx skills remove oms-meta oms-qa oms-coding oms-be-coding oms-fe-coding oms-review
```

---

## 支持的 Agent

| AI 工具 | `-a` 参数值 | 薄壳文件 |
|---|---|---|
| Claude Code | `claude-code` | `CLAUDE.md` |
| Codex CLI | `codex` | `CODEX.md` |
| Cursor | `cursor` | `AGENTS.md` |
| OpenCode | `opencode` | `AGENTS.md` |
| Gemini CLI | `gemini-cli` | `AGENTS.md` |
| GitHub Copilot | `github-copilot` | `AGENTS.md` |
| Windsurf | `windsurf` | `AGENTS.md` |
| Kiro CLI | `kiro-cli` | `AGENTS.md` |
| Roo Code | `roo` | `AGENTS.md` |
| Universal | `universal` | `AGENTS.md` |

---

## 安装钩子（可选）

`hooks/` 目录提供 SessionStart + PreToolUse 双钩子，用于对抗长会话上下文压缩。**不是必须的**——薄壳路由表已覆盖 80% 场景，钩子只补长会话/多 compact 场景下的最后 20%。

```bash
# Claude Code
cp hooks/hooks.json .claude/hooks.json

# Cursor
cp hooks/hooks-cursor.json .cursor/hooks.json
```

---

## 常见问题"}]

### 装完之后 AI 没自动按 `oms-*` 触发？

1. `npx skills list` 确认 skill 在已装列表里。
2. 检查对应目录是否存在 `oms-*/SKILL.md`。
3. 确认已加固薄壳：把 `shells/` 下对应文件复制到项目根目录。
4. 显式 prompt 一次"请先加载 `oms-meta`"，若有效说明是关键词匹配问题。

### 薄壳是什么？为什么需要它？

薄壳是放在项目根目录（如 `AGENTS.md`）的路由表精简版。Agent 长会话压缩上下文后，SKILL.md 可能不在上下文中，但薄壳里的结构化路由表会保留，让 Agent 仍能正确匹配任务到对应的 rules/workflows。

### Windows 需要开发者模式吗？

**不需要。** `vercel-labs/skills` 用 NTFS junction，失败时自动 fallback 到复制。

---

## Roadmap

- `oms-tools` — MCP 严格使用 / Context7 文档查询 / agent-browser 无痕
- `oms-git` — 提交规范 / 分支命名 / PR 流程 / commit message 风格
- `oms-platform-*` — 平台特定（macOS/Linux/Windows/PowerShell 等）

---

## License

MIT，见 `LICENSE`。
