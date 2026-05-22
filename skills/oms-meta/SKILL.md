---
name: oms-meta
description: 触发：每轮对话首轮 / 任何代码改动前 / 任何 oms-* skill 调用前。OhMySkills 最高优先级元规则集——优先级层级、不确定不假设、工具能力前置确认、reference-over-duplication、平台基线 (win/mac/linux)。
---

# OhMySkills 元规则 | Meta Rules

本 skill 是 OhMySkills 的**最高优先级元规则集**，应优先于其它 `oms-*` skill 加载。

**优先级层级**（priority chain，从高到低）：

```
用户当次对话明确要求
  > 项目级 AGENTS.md（更近层级）
    > 本 oms-meta 元规则
      > 其它 oms-* skills 默认行为
        > 工具内置默认
```

冲突时取更高层级。

## 5 条元规则 | The Five Core Rules

1. **优先级层级**：见上方层级图，冲突时取更高。

2. **不确定不假设**（no assumption without verification）：未读的代码、未查的接口、未见的库行为，必须显式标注「未确认」，并指出下一步如何确认（读哪个文件、查哪个文档、跑哪条命令）。禁基于印象、过时记忆、训练数据假设事实。

3. **工具能力前置确认 / 不擅自降级**（tool capability gating）：用户明确要求某 MCP / 工具时，若当前会话未暴露该工具，**直接停止并说明**；不擅自降级、不手工模拟、不假定可用。浏览器操作默认无痕（incognito only），当前工具不支持无痕就停止。

4. **skill 间引用而非复制**（reference over duplication）：跨 skill 引用另一 skill 的规则时，写「见 `$oms-X` 第 N 节」而非复制规则正文。避免双源漂移、维护成本翻倍。

5. **平台基线**（platform baseline）：见下方独立小节「平台基线表格」。AI 进入任何项目第一时间识别 OS，按对应列约束所有后续动作。

## 平台基线 | Platform Baseline

OhMySkills 面向多平台开发者分发。AI 在以下三大平台执行任何动作时必须遵守对应列约束：

| 维度 | Windows（PowerShell / Git Bash） | macOS（zsh / bash） | Linux（bash） |
|------|----------------------------------|----------------------|----------------|
| 文本 IO 编码 | **必须显式 UTF-8 无 BOM**（默认 ANSI/GBK 会乱码） | UTF-8 | UTF-8 |
| 路径分隔符 | 用语言内置 `path` API；禁手拼 `\` 或 `/` | `/` | `/` |
| Shell 类型 | PowerShell ≠ bash，命令不可互译；项目脚本默认 Git Bash | bash / zsh | bash |
| 行尾符 | 遵循 `.gitattributes`，禁主动引入 CRLF | LF | LF |
| 文件名大小写 | 不敏感（NTFS） | 不敏感（APFS 默认） | **敏感**（ext4），同名异 case 视为两文件 |
| 可执行权限 | 无 `chmod`，脚本靠扩展名 / shebang | `chmod +x` 必加 | `chmod +x` 必加 |
| 删除命令 | `Remove-Item` / `del`，**不是 `rm`** | `rm` | `rm` |
| 临时目录 | `$env:TEMP` | `$TMPDIR` 或 `/tmp` | `/tmp` |
| 环境变量语法 | `$env:VAR`（PS）/ `%VAR%`（cmd） | `$VAR` | `$VAR` |
| 二进制扩展名 | 带扩展名（`.exe` / `.cmd` / `.bat`） | 类 Unix（无强制扩展名） | 类 Unix（无强制扩展名） |

**表格使用约束**：

- 跨平台脚本：用语言内置 `path` / `fs` API，不用 shell 字符串拼接
- 文档示例命令默认给类 Unix 版（macOS / Linux），Windows 差异在脚注或独立小节说明
- 一次性脚本 / 调试代码也必须遵循对应平台的编码与行尾约束（不要因为「临时」就放宽）

## 反 anti-patterns

- ❌ 把本 skill 内容当成「可选建议」或「任务小就跳过」——元规则无论任务大小一律生效
- ❌ 假定本 skill 已加载就跳过引用——冲突仲裁时仍需显式引用本 skill 的对应条目
- ❌ 在 Windows 上写文本文件不显式 UTF-8 无 BOM，导致中文乱码
- ❌ 跨 skill 复制规则正文而非引用，导致同一规则在多处维护
- ❌ 工具不可用时不停止，手工模拟或假装成功
- ❌ 基于印象 / 过时记忆 / 训练数据假设事实，不做核实
