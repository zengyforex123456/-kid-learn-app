---
name: phase
description: SDLC 阶段管理 — 查看当前阶段、推进到下一阶段、或回退阶段。
---

# /phase — SDLC 阶段管理

## 用法
- `/phase` — 查看当前阶段和状态
- `/phase next` — 推进到下一阶段（需通过门禁检查）
- `/phase set P2` — 手动设置阶段（谨慎使用）

## 阶段说明
| 阶段 | 名称 | 核心活动 |
|------|------|---------|
| P1 | 需求分析+设计 | 5 决策点：需求澄清→技术调研→PRD→架构→原型 |
| P2 | 编码实现 | 按 PRD 编码，可并行派发 sdlc-coder |
| P3 | 测试验证 | 单元/集成/UI/E2E 测试，覆盖率达标 |
| P4 | 综合审查 | 代码/测试/集成/UI 四维审查 |
| P5 | 部署交付 | git commit/push + PR + 文档 |

## 门禁检查
推进到下一阶段前自动检查：
- P1→P2: 5 决策点全部确认、PRD 文件存在
- P2→P3: 代码编写完成、modified_files 非空
- P3→P4: 测试全部通过、覆盖率达标
- P4→P5: 审查通过（0 阻断问题）

## 操作
1. 读取 `.claude/project-state.md`
2. 显示当前阶段和状态摘要
3. 如推进，执行门禁检查
4. 更新 `project-state.md` 的 `current_phase` 和 `phase_history`
