---
name: archive
description: 归档已完成任务到 .claude/archive/，清理项目状态。
---

# /archive — 归档完成任务

## 操作
1. 将 `completed_tasks` 中已归档的任务写入 `.claude/archive/tasks-{year}.md`
2. 精简 `project-state.md`：
   - `completed_tasks` 保留最近 3 个
   - `phase_history` 保留最近 5 条
   - `key_context` 压缩到 ≤50 字
3. 重置 `modified_files` 为空

## 归档格式
```yaml
- task: "任务描述 ≤20字"
  prd_summary: "R1:需求1 R2:需求2"
  key_decisions: ["技术栈", "架构"]
  files_count: N
  completed_at: "YYYY-MM-DD"
```

## 自动触发
- completed_tasks ≥ 5 → 自动归档最旧 2 个
- phase_history ≥ 10 → 合并重复项
