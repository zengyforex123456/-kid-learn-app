---
name: review
description: 触发 SDLC P4 代码审查 — 可指定审查维度或全面审查。
---

# /review — 触发代码审查

## 用法
- `/review` — 全面审查（所有维度）
- `/review code` — 仅代码审查
- `/review test` — 仅测试审查
- `/review ui` — 仅 UI 审查

## 审查流程
1. 自动检测项目类型（Node.js/Python/Go/Rust/Java）
2. 执行对应审查工具链（见 `06-review-tools.md`）
3. 生成审查报告（≤15 行）
4. 发现阻断问题 → 自动修复（最多 3 次）→ 重审
5. 通过 → 更新状态，推进 P5

## 审查工具链
- Lint + Typecheck + Build + 依赖审计
- 测试覆盖率验证
- PRD 四环追溯（需求→架构→代码→测试）

## 并行审查
当 modified_files ≥ 5 时，自动派发 sdlc-reviewer Agent（最多 3 个维度并行）。
