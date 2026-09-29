<context_session_file>
#$ARGUMENTS
</context_session_file>

# Create New GitHub Issue

## Input
Feature/Bug/Chore plan: $ARGUMENTS

## Step 1: Analysis
- Analyze the feature/bug/chore idea provided
- Look at relevant code files to understand current and needed implementation
- Determine if this involves multiple features → if yes, go to **Step 1b: Epic**

## Step 1b: Epic (only when multiple features are involved)

If the request covers 2+ distinct features, create an Epic issue first:
- Title: `[Epic] <nombre del epic>`
- Body: objetivo global + lista de issues hijo (se irán enlazando)
- Label: `epic`

Then create one child issue per feature. Each child issue must reference the epic: `Parte del epic #NNN`.

**Parallelization safety check — run before defining child issues:**

For each pair of child issues, check if they touch overlapping files. Apply this rule:
> **Two issues CANNOT run in parallel if they modify the same file.**
> The second issue must wait until the first is merged.

In the Epic body, include an explicit dependency table:

| Issue | Depends on | Can start when |
|-------|-----------|----------------|
| #A — Feature X | — | immediately |
| #B — Feature Y | #A | #A merged |
| #C — Feature Z | — | immediately (different files) |

## Step 2: Draft Issue
Create an issue with this structure:

### Problem Statement
What problem does this solve? What are current limitations?

### User Value
What specific benefits will users get? Give concrete examples.

### Definition of Done
- Implementation complete with edge cases handled
- Tests added
- Code review approved
- CI passes
- Manual testing complete

### Manual Testing Checklist
- Basic flow: [specific steps]
- Edge case testing: [specific scenarios]
- Error handling: [error scenarios to test]
- Integration: [test with existing features]

## Step 3: Review
Show the complete issue draft and ask: "Is this ready to create? Any changes needed?"

Wait for approval.

## Step 4: Create Issue
After approval, run:
```
gh issue create --title "[Feature/Bug/Chore] YOUR_TITLE_HERE" --body "YOUR_ISSUE_CONTENT_HERE"
```

Report the issue number and URL when done.

## Remember
- Check actual code before suggesting solutions
- Use specific file names and paths
- Make testing steps concrete and actionable
- Triage correctly: is it a feature, a bug, or a chore?
