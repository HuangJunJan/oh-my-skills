# OhMySkills

> **跨 AI 编程工具通用的 Skills 仓库。** 通用编码规则一次维护、按需安装，不再每个项目复制同步 `AGENTS.md`。

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

完事。**装完即用，无需任何手动初始化**——AI 会按 skill description 关键词自动加载 3 个 skill，`oms-meta` 的 5 条元规则在每次新会话开始时优先生效。

---

## 提供的 Skills | Shipped Skills

| Skill | 主题 | 何时生效 |
|---|---|---|
| `oms-meta` | 最高优先级元规则（优先级层级 / 不确定不假设 / 工具能力前置确认 / 单一事实源 / 平台基线） | 任何对话开始时；任何代码改动 / oms-* skill 触发之前 |
| `oms-qa` | 通用问答交互（回复风格 + 严审/盘问模式） | 每轮对话默认；触发词进入盘问模式 |
| `oms-coding` | 通用编程规范（编码前/中、变更安全、敏感操作、验证、交付） | 任何代码改动 / 验证 / 交付任务 |

3 个 skill 都靠 description 关键词由 AI 自动触发，不需要 slash command、不需要手动初始化、不在用户项目里创建任何额外目录。

---

## 装 | Install

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
npx skills add HuangJunJan/oh-my-skills -s oms-meta -s oms-coding

# 全局安装（默认是项目级；加 -g 装到用户主目录）
npx skills add HuangJunJan/oh-my-skills -g

# 版本钉（推荐团队协作时使用）
npx skills add HuangJunJan/oh-my-skills@v0.1.1
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

## 用 | Use

**装完即用，无需任何手动初始化步骤**。`oms-meta` / `oms-qa` / `oms-coding` 都靠 AI 工具按 description 关键词自动触发匹配。典型场景示例：

| 用户说 | 触发的 skill | 触发段 |
|---|---|---|
| 任何对话开始 / 任何代码任务之前 | `oms-meta` | 5 条元规则全局生效 |
| 「按 brainstorm 严审我的方案」/「grill me」 | `oms-qa` | B 段 盘问模式 |
| 「改一下这个组件」/「加个新接口」 | `oms-coding` | A/B/C 段 编码规范 + 变更安全 |
| 「改一下 .env 文件」 | `oms-coding` | D 段 敏感操作（默认只读） |
| 「跑一下全量 type-check」 | `oms-coding` + `oms-meta` 第 5 条 | E 段 验证策略（劝阻 + 让用户明确确认） |

### 优先级

冲突时取更高：

```
用户当次对话明确要求
  > 项目级 AGENTS.md（更近层级）
    > oms-meta（本仓库 5 条元规则）
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

> **从 v0.1 升级到 v0.1.1 的用户**：v0.1.1 起 `oms-onboard` 已弃用，被 `oms-meta` 取代。先一次性 `npx skills remove oms-onboard` 清掉旧 skill，再正常 `npx skills update` 即可拿到 `oms-meta`。

---

## 卸载 | Uninstall

```bash
# 显式列出要卸载的 skill
npx skills remove oms-meta oms-qa oms-coding

# 交互式选择
npx skills remove
```

卸载只清理 `.agents/skills/oms-*` 与各 agent 目录下的引用。v0.1.1 起本仓库不再在用户项目里创建任何额外目录，无残留需手动清理。

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

> Universal agents 共享 `./.agents/skills/` 作为 canonical 路径；Claude Code 是 non-universal（独立 `.claude/skills/`）。agent 特定目录是 junction / symlink 指向 canonical，节省磁盘且改一处全生效。

---

## 常见问题 | FAQ

### Q. Windows 需要开发者模式吗？
**不需要。** `vercel-labs/skills` 用 NTFS junction（普通用户即可创建），不是 symlink；junction 失败时自动 fallback 到复制。

### Q. 运行 `npx skills add` 报「repository not found / 404」？
原因：仓库未公开，或 `HuangJunJan/oh-my-skills` 拼错。`npx skills add` 通过 GitHub Trees API 拉取，必须能匿名访问。
排查：
- 浏览器打开 `https://github.com/HuangJunJan/oh-my-skills`，确认能匿名看到（无登录态时）。
- 仓库 Settings → General → Danger Zone 改为 Public。
- 或先用 `--list` 验证：`npx skills add HuangJunJan/oh-my-skills --list`。

### Q. 装完之后 AI 没自动按 `oms-meta` / `oms-qa` / `oms-coding` 触发？
原因可能：(a) AI 工具版本太旧未支持 SKILL.md progressive disclosure；(b) skill 未正确安装到该工具识别的目录。
排查：
- 用 `npx skills list` 确认 3 个 skill 在已装列表里。
- 检查工具对应目录是否存在 `oms-*/SKILL.md` 文件（路径见上方「支持的 Agent」表）。
- 在当前会话里显式 prompt 一次「请先加载并应用 `oms-meta` 5 条元规则」，若有效说明是触发关键词匹配问题——给作者提 issue 我们补 description 关键词。

### Q. 已经装了同名的 skill（比如别的 `oms-coding`）会冲突吗？
`vercel-labs/skills` 默认 silent overwrite。`oms-` 前缀本身就是为了降低冲突概率；如确实有同名包先 `npx skills remove <名字>` 再装本仓库。

### Q. 团队协作怎么钉版本？
推荐用 `@v0.1.1` 或 `@<commit-sha>` 形式装：
```bash
npx skills add HuangJunJan/oh-my-skills@v0.1.1
```
安装后会生成 `./skills-lock.json`，把它提交进 git 即可让全员锁定同一版。

---

## Roadmap

MVP 阶段（v0.1.1）只交付 3 个 skill：`oms-meta` / `oms-qa` / `oms-coding`。后续候选（**不在当前范围**）：

- `oms-tools` — MCP 严格使用 / Context7 文档查询 / agent-browser 无痕
- `oms-git` — 提交规范 / 分支命名 / PR 流程 / commit message 风格
- `oms-review` — 代码 review 标准 / 自审清单
- `oms-platform-*` — 平台特定（macOS / Linux 等）

新增 skill 时仓库结构无需重构，只需在 `skills/` 下新增目录、SKILL.md 写好 YAML frontmatter（`name` 与目录名一致），push 后用户跑 `npx skills update` 即可拿到。

---

## License

MIT，见 `LICENSE`。**v0.1 起开源**——`npx skills add` 需要 GitHub 公开访问，本仓库已对外开放，欢迎 fork / 提 issue / 提 PR。
