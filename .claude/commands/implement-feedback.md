# GitHub Feedback Workflow for Issue #$ARGUMENT$

## Setup Phase
1. Fetch latest branches: `git fetch origin`
2. Get issue details:
   ```bash
   gh issue view $ARGUMENT$ --json number,title,body,comments
   ```

## Analysis Phase
1. Read the full issue content and ALL comments: `gh issue view $ARGUMENT$ --comments`
2. If `.claude/sessions/review_spec_$ARGUMENT$.md` exists, read it for review feedback
3. Analyze the requirements, context, and feedback thoroughly

## Implementation Phase
1. Plan the changes needed to address the feedback
2. Execute step by step — TDD: write test first, then implement, run suite constantly
3. Ensure consistency with existing code in the branch
4. Run the full test suite before committing
5. Never implement manual tests
6. Commit and push the changes to update the PR

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
# PR: github-pr-url
```

8. Monitor CI: `gh pr view {pr_number} --json statusCheckRollup,state,mergeable,url`
9. If CI fails → diagnose, fix, push again. Loop until green.

## Important Notes
- "All Completed" requires ALL requirements implemented AND all tests green
- Always use `gh` CLI for GitHub operations
- Wait for explicit confirmation before major changes
