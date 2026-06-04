# OhMySkills

> **跨 AI 编程工具通用的 Skills 仓库。** 通用编码、问答、审查和前后端规则一次维护、按需安装，不再每个项目复制同步 `AGENTS.md`。

---

## 是什么 | What is this

每个项目根目录都有一份 `AGENTS.md`（或 `CLAUDE.md`、`now.md`），文件越来越长、规则在多个项目间漂移、改一处要同步 N 处。

OhMySkills 的方案：**通用规则集中在一个公开 GitHub 仓库**，用现成的 [`vercel-labs/skills`](https://github.com/vercel-labs/skills)（npm 包 `skills`）一行命令分发到 10+ 种 AI 编程工具。仓库即事实源，用户随时 `npx skills update` 拉新版，跨项目、跨工具自动生效。

本仓库自身**不写任何安装脚本**（无 Python / 无 Shell / 无 `package.json`），全部交给 `vercel-labs/skills` 处理。

---

## 快速上手 | Quick Start

```bash
# 装到当前项目，自动适配所有已用的 AI 工具
npx skills add HuangJunJan/oh-my-skills --all
```

完事。**装完即用，无需任何手动初始化**——AI 会按 skill description 关键词自动加载对应规则；`oms-meta` 的元规则在新会话和代码任务前优先生效。

---

## 提供的 Skills | Shipped Skills

| Skill | 主题 | 何时生效 |
|---|---|---|
| `oms-meta` | 最高优先级元规则：优先级、事实核验、工具能力、平台基线、证据完整性、skill 分层维护边界 | 每轮对话首轮；任何代码改动前；任何 oms-* skill 调用前 |
| `oms-qa` | 通用问答交互：中文默认、先结论、少问多查、推荐优先、需求收敛、盘问 / 严审模式 | 每轮对话默认；用户要求盘问、严审、挑战方案、stress-test、grill me 时 |
| `oms-coding` | 通用编码执行：先读再改、复用优先、最小改动、根因修复、验证、交付前自检 | 任何代码改动 / 新增 / 删除 / 验证 / 交付任务 |
| `oms-be-coding` | 后端领域规范：API 契约、数据层、错误可观测性、并发韧性、安全配置、后端验证 | 后端代码或后端项目编码任务 |
| `oms-fe-coding` | 前端领域规范：状态分层、接口契约、UI/a11y、性能、TypeScript、前端验证 | 前端代码或前端项目编码任务 |
| `oms-review` | 通用审查规范：事实核验、风险分级、必须修 vs 建议、输出格式、误报防护 | 代码审查 / PR review / diff review / 方案 review / 安全审查 |

这些 skill 都靠 description 关键词由 AI 自动触发，不需要 slash command、不需要手动初始化、不在用户项目里创建任何额外目录。

---

## 安装 | Install

底层全部走 `npx skills`。常用命令矩阵：

```bash
# 一行装（推荐）：自动检测已装 agent，装到当前项目
npx skills add HuangJunJan/oh-my-skills

# 装全部 skill 到全部已检测到的 agent，不交互
npx skills add HuangJunJan/oh-my-skills --all

# 指定 agent（可多个）
npx skills add HuangJunJan/oh-my-skills -a claude-code
npx skills add HuangJunJan/oh-my-skills -a claude-code -a codex

# 指定 skill（可多个）
npx skills add HuangJunJan/oh-my-skills -s oms-coding
npx skills add HuangJunJan/oh-my-skills -s oms-meta -s oms-coding -s oms-review

# 全局安装（默认是项目级；加 -g 装到用户主目录）
npx skills add HuangJunJan/oh-my-skills -g

# 版本钉（推荐团队协作时使用）
npx skills add HuangJunJan/oh-my-skills@<tag>
npx skills add HuangJunJan/oh-my-skills@<commit-sha>

# 远端列出仓库里有哪些 skill（不安装）
npx skills add HuangJunJan/oh-my-skills --list
```

安装后项目里会出现：

- `./.agents/skills/oms-*/`（universal agents 的 canonical 路径）
- `./.claude/skills/oms-*/`（Claude Code 专属，junction / symlink 指向 canonical）
- `./skills-lock.json`（版本锁，提交进 git 让团队同步）

> Windows 用户**无需开发者模式**：`vercel-labs/skills` 用 NTFS junction（不是 symlink），失败时自动 fallback 到复制。

---

## 使用 | Use

**装完即用，无需任何手动初始化步骤**。典型场景示例：

| 用户说 | 触发的 skill | 触发段 |
|---|---|---|
| 任何对话开始 / 任何代码任务之前 | `oms-meta` | 元规则全局生效 |
| “按 brainstorm 严审我的方案” / “grill me” | `oms-qa` | 盘问 / 严审模式 |
| “改一下这个组件” / “加个新接口” | `oms-coding` | 通用编码执行规范 |
| “给 NestJS 加一个接口” / “修 SQL 查询” | `oms-coding` + `oms-be-coding` | 通用编码 + 后端领域规范 |
| “改 Vue 页面布局” / “修 React hook” | `oms-coding` + `oms-fe-coding` | 通用编码 + 前端领域规范 |
| “帮我 review 这个 PR / diff / 方案” | `oms-review` | 审查规范 |
| “改一下 .env 文件” | `oms-coding` | 敏感边界：默认只读，需明确要求 |
| “跑一下全量 build / publish” | `oms-coding` + `oms-meta` | 敏感命令：先说明原因并确认 |

### 优先级

冲突时取更高：

```text
用户当次对话明确要求
  > 项目级 AGENTS.md / CLAUDE.md / now.md（更近层级）
    > oms-meta
      > 其它 oms-* skills 默认行为
        > 工具内置默认
```

---

## 更新 | Update

```bash
# 检测并更新所有已装 skill
npx skills update

# 只更新某一个
npx skills update oms-coding
```

更新只是把仓库最新内容拉下来重新替换 canonical 目录的文件，已建立的 junction / symlink 不需要重建。

---

## 卸载 | Uninstall

```bash
# 显式列出要卸载的 skill
npx skills remove oms-meta oms-qa oms-coding oms-be-coding oms-fe-coding oms-review

# 交互式选择
npx skills remove
```

卸载只清理 `.agents/skills/oms-*` 与各 agent 目录下的引用。

---

## 支持的 Agent | Supported Agents

| AI 工具 | `-a` 参数值 | 项目模式安装路径 | 全局模式安装路径 |
|---|---|---|---|
| Claude Code | `claude-code` | `./.claude/skills/` | `~/.claude/skills/` |
| Codex CLI | `codex` | `./.agents/skills/` | `~/.codex/skills/` |
| Cursor | `cursor` | `./.agents/skills/` | `~/.cursor/skills/` |
| OpenCode | `opencode` | `./.agents/skills/` | `~/.config/opencode/skills/` |
| Gemini CLI | `gemini-cli` | `./.agents/skills/` | `~/.gemini/skills/` |
| GitHub Copilot | `github-copilot` | `./.agents/skills/` | `~/.copilot/skills/` |
| Windsurf | `windsurf` | `./.windsurf/skills/` | `~/.codeium/windsurf/skills/` |
| Kiro CLI | `kiro-cli` | `./.kiro/skills/` | `~/.kiro/skills/` |
| Roo Code | `roo` | `./.roo/skills/` | `~/.roo/skills/` |
| Universal（通用兜底） | `universal` | `./.agents/skills/` | `~/.agents/skills/` |

> Universal agents 共享 `./.agents/skills/` 作为 canonical 路径；Claude Code / Windsurf / Kiro / Roo 是 non-universal（各有独立目录 `.claude/` / `.windsurf/` / `.kiro/` / `.roo/`）。agent 特定目录是 junction / symlink 指向 canonical，节省磁盘且改一处全生效。

---

## 常见问题 | FAQ

### Q. Windows 需要开发者模式吗？

**不需要。** `vercel-labs/skills` 用 NTFS junction（普通用户即可创建），不是 symlink；junction 失败时自动 fallback 到复制。

### Q. 运行 `npx skills add` 报 “repository not found / 404”？

原因：仓库未公开，或 `HuangJunJan/oh-my-skills` 拼错。`npx skills add` 通过 GitHub Trees API 拉取，必须能匿名访问。

排查：

- 浏览器打开 `https://github.com/HuangJunJan/oh-my-skills`，确认能匿名看到（无登录态时）。
- 仓库 Settings → General → Danger Zone 改为 Public。
- 或先用 `--list` 验证：`npx skills add HuangJunJan/oh-my-skills --list`。

### Q. 装完之后 AI 没自动按 `oms-*` 触发？

原因可能：AI 工具版本太旧未支持 SKILL.md progressive disclosure，或 skill 未正确安装到该工具识别的目录。

排查：

- 用 `npx skills list` 确认 skill 在已装列表里。
- 检查工具对应目录是否存在 `oms-*/SKILL.md` 文件（路径见上方「支持的 Agent」表）。
- 在当前会话里显式 prompt 一次“请先加载并应用 `oms-meta`”，若有效说明是触发关键词匹配问题——可以提 issue 补 description 关键词。

### Q. 已经装了同名 skill 会冲突吗？

`vercel-labs/skills` 默认 silent overwrite。`oms-` 前缀本身就是为了降低冲突概率；如确实有同名包先 `npx skills remove <名字>` 再装本仓库。

### Q. 团队协作怎么钉版本？

推荐用 tag 或 commit sha：

```bash
npx skills add HuangJunJan/oh-my-skills@<tag>
npx skills add HuangJunJan/oh-my-skills@<commit-sha>
```

安装后会生成 `./skills-lock.json`，把它提交进 git 即可让全员锁定同一版。

---

## Roadmap

当前已覆盖：元规则、问答、通用编码、后端编码、前端编码、审查。

后续候选：

- `oms-tools` — MCP 严格使用 / Context7 文档查询 / agent-browser 无痕。
- `oms-git` — 提交规范 / 分支命名 / PR 流程 / commit message 风格。
- `oms-platform-*` — 平台特定（macOS / Linux / Windows / PowerShell 等）。

新增 skill 时仓库结构无需重构，只需在 `skills/` 下新增目录、`SKILL.md` 写好 YAML frontmatter（`name` 与目录名一致），push 后用户跑 `npx skills update` 即可拿到。

---

## License

MIT，见 `LICENSE`。
