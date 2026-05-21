---
name: oms-onboard
description: OhMySkills 项目初始化引导——复制 _core 元规则到当前项目，并告知 AI 后续会话首先读取它。触发：用户首次在项目里接入 OhMySkills；用户说「初始化 OhMySkills」「oms 初始化」「/oms-onboard」；项目根目录不存在 ./.oms/reference/_core.md 时建议触发。
---

# OhMySkills 项目初始化引导 | Onboard

本 skill 是 OhMySkills 在项目里的**一次性入口**。它把本 skill 自带的 `reference/_core.md`（5 条最高优先级元规则）复制到当前工作目录的 `./.oms/reference/_core.md`，让后续每次新会话开始时 AI 都能先读到它。

## A. 一次性任务 | One-Off Task

> AI 助手收到 `/oms-onboard` 调用或检测到本 skill 触发关键词时，按以下步骤执行**一次**：

1. **确认目标路径**：以用户当前工作目录（cwd）为根，目标文件路径为 `./.oms/reference/_core.md`。
2. **检查存在性**：
   - 若目标文件**已存在**：先读取一遍并与本 skill `reference/_core.md` 对比；若内容一致则告知用户「`_core.md` 已是最新，无需重复」并结束；若不一致则**先询问用户**是否覆盖（提示「本地版本可能含你的手工修改」），用户明确同意后再覆盖。
   - 若目标文件**不存在**：进入下一步。
3. **创建父目录**：`mkdir -p ./.oms/reference`（已存在则跳过；Windows / macOS / Linux 均按当前工具的标准目录创建 API 执行，禁止用 `rm -rf` 类破坏命令）。
4. **复制 `_core.md`**：把本 skill 同目录下 `reference/_core.md` 的**完整文本**写入 `./.oms/reference/_core.md`。使用 UTF-8 无 BOM 写入。
5. **校验**：复制后读回一次，确认文件存在且字节数 > 0；首行应为 `# OhMySkills _core 元规则`。

## B. 持久化提示 | Persistence Notice

复制成功后，**显式告诉用户**（中文输出，无 emoji）：

> 已把 OhMySkills `_core` 元规则复制到 `./.oms/reference/_core.md`。
>
> **以后每次新会话开始时，请先读 `./.oms/reference/_core.md` 作为最高优先级元规则**（其优先级高于 skills 默认行为、低于项目级 `AGENTS.md` 与用户当次明确要求）。
>
> 建议把以下一行加进本项目根 `AGENTS.md`（如果有的话），让所有 agent 都能自动看到：
>
> ```
> 本项目遵循 OhMySkills _core 元规则：每次新会话开始时先读 ./.oms/reference/_core.md
> ```

注意：**不**主动替用户改 `AGENTS.md`，只给出建议片段让用户自己粘贴。

## C. 反 anti-patterns | Don'ts

- ❌ **不修改用户的 `AGENTS.md` / `CLAUDE.md`**：即使发现没引用 `_core`，也只能在输出里建议片段，不替用户写文件。
- ❌ **不在 `.oms/` 以外建任何目录或文件**：不创建 `.ohmyskills/`、不在项目根放 `OMS_README.md`、不修改 `.gitignore`。
- ❌ **不静默覆盖**：目标文件已存在且内容不同时，必须先问用户；不要假装更新成功。
- ❌ **不重复执行**：本 skill 是一次性的；同一项目里第二次被触发时应先检测 `_core.md` 是否已存在、内容是否一致，避免无意义覆写。
- ❌ **不下载 / 不联网**：所有要复制的内容都来自本 skill 同目录下 `reference/_core.md`，不去 GitHub 拉、不去 npm 取。
- ❌ **不删除任何文件**：本 skill 永不执行 `rm` / `Remove-Item` / `del`。
