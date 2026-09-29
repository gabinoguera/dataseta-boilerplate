<github_issue>
#$ARGUMENTS
</github_issue>

# Worktree TDD — Issue #$ARGUMENTS

1. Create worktree:
   ```bash
   git worktree add ./.trees/feature-issue-$ARGUMENTS -b feature/issue-$ARGUMENTS
   ```

2. Register the worktree sentinel:
   ```bash
   mkdir -p .claude/.worktrees_active
   echo "$(pwd)/.trees/feature-issue-$ARGUMENTS" > .claude/.worktrees_active/feature-issue-$ARGUMENTS
   ```

3. Fetch the issue and read the spec if it exists:
   ```bash
   gh issue view $ARGUMENTS --json number,title,body,comments
   ```
   If `.claude/sessions/issue_spec_$ARGUMENTS.md` exists, read it — it's the source of truth for implementation phases.

4. **Plan**: Enter plan mode. Analyze the issue (and spec if available) and determine:
   - What needs to be built, phase by phase
   - Which phases can run in parallel vs sequential
   - Present the plan to the user and **wait for confirmation**

5. **Implement in TDD**, functionality by functionality, step by step:
   - Write test first → implement → verify → next piece
   - Don't create the full test suite then the full implementation — decouple into small pieces
   - Run the test suite constantly for quick feedback
   - Never implement manual tests (those are for QA)

6. **IMPORTANT**: ALL file edits MUST use absolute paths within the worktree (`.trees/feature-issue-$ARGUMENTS/`). NEVER edit files in the main working tree.

7. Generate implementation report with:
   - Summary of requirements implemented
   - Requirements pending (if any)
   - Tests implemented and their run status
   - Proof that all tests pass
   - Overall status: [Needs More Work / All Completed]

8. At the end, after user confirmation:
   - Commit the changes
   - Push to the branch
   - Create PR if needed

9. Clean up sentinel:
   ```bash
   rm -f .claude/.worktrees_active/feature-issue-$ARGUMENTS
   ```
