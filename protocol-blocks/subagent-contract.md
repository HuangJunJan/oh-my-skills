# Subagent 子任务合约

## 五个必填字段

```markdown
## Goal
<一句话，面向结果。不微管步骤。>

## Inputs
<worker 允许读的确切文件/目录。一行一个。>
- `path/to/file.ts`
- `path/to/directory/`

## Outputs
<worker 必须产出/修改的确切文件。一行一个。>
- `path/to/output.ts`

## Forbidden Zones
<不许碰的文件/目录/副作用。不确定默认禁。>
- `/*` 除非在 Inputs 中明确列出
- 不允许执行 `git commit` / `git push`
- 不允许修改 `.env*` 文件

## Acceptance Criteria
<可机械验证的命令，一行一个。>
- `yarn tsc --noEmit`
- `yarn test --run`
```

## 规则

- 任何字段不能空
- Goal 面向结果，不微管步骤
- Acceptance 必须是可执行检查，不是散文
- worker 不得改合约——合约错了是主 Agent 重写重派
- 有依赖的任务在前，无依赖的并行派发