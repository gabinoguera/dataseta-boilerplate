# Local Feedback Implementation for Task: $ARGUMENT$

## Setup Phase
1. Read task details from `.trees/task_plan_$ARGUMENT$.md` or task description

## Analysis Phase
1. Read the full task description and requirements
2. Read the feedback from `.trees/feature-task-$ARGUMENT$/task_review.md`
3. Analyze the requirements, context, and feedback thoroughly

## Implementation Phase
1. Plan the changes needed to address the feedback
2. Execute step by step — TDD: write test first, then implement, run suite constantly
3. Ensure consistency with existing code in the branch
4. Run the full test suite before committing
5. Never implement manual tests
6. Update the task report: `.trees/feature-task-$ARGUMENT$/task_report.md`

7. Report status:

```
# Summary of requirements implemented:
  - req 1
  - req 2

# Requirements pending:
  - req 1

# Tests implemented and their run status:
  ok    path/to/test_file       Xs

# Proof that all tests pass:
  ok    all tests passed         Xs

# Overall status: [Needs More Work / All Completed]
```

8. Loop: run all tests → if failures → fix → repeat until green
9. After user confirmation, commit locally (no push)

## Important Notes
- "All Completed" requires ALL requirements implemented AND all tests green
- Work entirely locally, no GitHub operations
- Keep records in `.trees/feature-task-$ARGUMENT$/` directory
