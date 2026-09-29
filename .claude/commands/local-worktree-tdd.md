<task_description>
#$ARGUMENTS
</task_description>

# Local Worktree TDD — $ARGUMENTS

1. Create worktree:
   ```bash
   git worktree add ./.trees/feature-local-$ARGUMENTS -b feature/local-$ARGUMENTS
   ```

2. Register the worktree sentinel:
   ```bash
   mkdir -p .claude/.worktrees_active
   echo "$(pwd)/.trees/feature-local-$ARGUMENTS" > .claude/.worktrees_active/feature-local-$ARGUMENTS
   ```

3. **Plan**: Enter plan mode. Analyze the task description and determine:
   - What needs to be built, phase by phase
   - Which phases can run in parallel vs sequential
   - Present the plan to the user and **wait for confirmation**

4. **Implement in TDD**, functionality by functionality, step by step:
   - Write test first → implement → verify → next piece
   - Don't create the full test suite then the full implementation — decouple into small pieces
   - Run the test suite constantly for quick feedback
   - Never implement manual tests

5. **IMPORTANT**: ALL file edits MUST use absolute paths within the worktree (`.trees/feature-local-$ARGUMENTS/`). NEVER edit files in the main working tree.

6. Generate implementation report in `.trees/feature-local-$ARGUMENTS/task_report.md`:
   - Summary of requirements implemented
   - Requirements pending (if any)
   - Tests implemented and their run status
   - Proof that all tests pass
   - Overall status: [Needs More Work / All Completed]

7. At the end, after user confirmation, commit the changes locally (no push).

8. Clean up sentinel:
   ```bash
   rm -f .claude/.worktrees_active/feature-local-$ARGUMENTS
   ```
