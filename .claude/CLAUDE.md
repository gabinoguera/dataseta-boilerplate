# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Aurea is a collaborative video editing platform with AI-powered content generation. It's a React 18 + TypeScript SPA built with Vite, deployed on AWS Amplify.

## Commands

```bash
npm run prod-aurea-b2c    # Dev server on port 5191
npm run build             # Production build (outputs to /dist)
npm run lint              # ESLint
npm run preview           # Preview production build on port 5187
```

No test framework is configured.

## Architecture

### State Management
- **ProjectContext** (`src/contexts/ProjectContext.tsx`): Global project state (current project, project list, loading)
- **EditorContext** (`src/contexts/EditorContext.tsx`): Editor-specific state
- **Liveblocks** (`liveblocks.config.ts`): Real-time collaboration — presence, shared storage for canvas/story/clips state, broadcast events

### Routing (React Router v7)
Defined in `src/App.tsx`. The app has four main tabs within the authenticated view: Dashboard, Canvas, Chat, and Clips. Mobile devices default to Chat tab, desktop to Canvas.

Key routes: `/` (landing or dashboard based on auth), `/en` (English landing), `/story-creation`, `/billing`, `/admin/*`, `/partner/*`, `/share/:shareId`, `/join/:shareToken`, `/media/:shareId`.

### Service Layer (`src/services/`)
Dedicated service files for each external integration following a consistent pattern. Major services:
- `strapi.ts` — CMS data management (project CRUD, users, content)
- `contentGenerationService.ts` — AI content generation orchestration
- `effectsManager.ts` — Visual effects pipeline
- `audioManager.ts` — Audio handling and processing
- `elevenlabs.ts` — Voice synthesis
- `s3.ts` — AWS S3 file uploads
- `groq-api.ts` — Groq LLM integration
- `imageGenerationService.ts` — FAL-AI image generation
- `mastraService.ts` — Workflow automation
- `transitionsManager.ts` — Video transitions

### Canvas & Rendering
Multiple canvas technologies coexist:
- **Fabric.js** (`fabric` v5) — Primary canvas manipulation
- **Konva** / **react-konva** — 2D graphics layer
- **Pixi.js** v8 — GPU-accelerated rendering, adapted via `src/utils/pixiCanvasAdapter.ts`
- **Remotion** — Video composition and export
- **GSAP** — Animation timelines

### Web Workers
- `public/exportWorker.js` — Video export (offloaded from main thread)
- `public/segmentationWorker.js` — Image segmentation
- `src/workers/segment.worker.ts` — Segment processing

### Key Utility Files
- `src/utils/renderUtils.ts` — Video rendering pipeline (large file)
- `src/utils/audioUtils.ts` — Audio processing utilities
- `src/utils/pixiCanvasAdapter.ts` — Adapter abstracting Pixi.js canvas

## Configuration

### Path Alias
`@` maps to `./src` (configured in `vite.config.ts`). Use `@/components/...`, `@/services/...`, etc.

### TypeScript
Strict mode enabled with `noUnusedLocals` and `noUnusedParameters`. Target ES2020, JSX react-jsx.

### Vite
- styled-jsx babel plugin enabled
- `next/navigation` is mocked at `src/mocks/next-navigation.ts` (compatibility shim)
- Dev proxy: `/api` routes to `https://magnetic.aureasuite.ai`

### Deployment
AWS Amplify builds from `amplify.yml`. Environment variables are injected from Amplify secrets into `.env.production` at build time. All env vars use the `VITE_` prefix.

## Conventions

- **Styling**: Tailwind CSS utility classes. Avoid custom CSS.
- **Components**: PascalCase filenames, organized by feature domain under `src/components/` (e.g., `clips/`, `dashboard/`, `story/`, `ui/`).
- **Hooks**: `src/hooks/` with `use` prefix. Business logic goes here, not in components.
- **Services**: camelCase filenames in `src/services/`. One file per external integration.
- **Types**: Centralized in `src/types/`.
- **ESLint rule**: `@typescript-eslint/no-unused-expressions` is disabled.

## Development Philosophy

The key is **progressive simplicity**: a basic, intuitive interface for beginners, but one that reveals advanced tools when needed. Priorities should be:

* **Real-time preview** always visible
* **Accessible timeline** with optimized touch controls
* **Direct access** to the most frequently used functions
* **Layered workflows** (basic → advanced)

### Fundamental Principle: Simplicity Over Architecture

**IMPORTANT**: This project prioritizes simple, straightforward implementations over complex architectural patterns.

- **DO NOT create new contexts** unless absolutely necessary
- **DO NOT create reducers** or centralized state systems without explicit approval
- **DO NOT create multiple new files** when functionality can be added inline
- **commits** Always in English, never Add this leyend "Co-Authored-By: Claude..."
- **docs** Documentation files (openspec, CLAUDE, mcp.json, etc.) are listed in .gitignore and should never be committed.
- **Modify existing files** rather than introducing new abstractions

### Approach for New Features

1. **Implement changes within the existing file** (e.g., `ClipsTimeline.tsx`)
2. **Add state using useState** where similar state already exists
3. **Reuse existing hooks and functions** before creating new ones
4. **Keep changes small and easily verifiable** - run `npm run build` frequently
5. **Do not break existing behavior** - test before and after each change

## Implementation Workflow

### Build verification
Run `npm run build` after completing each task group or spec. Do not accumulate multiple groups without verifying compilation.

### Commits
Commit per spec or task group, not one monolithic commit at the end. Message format: `feat(scope): description` where scope matches the spec or capability name (e.g., `feat(clips/display-trim): migrate data model to display/trim`).

### Parallel execution
When implementing OpenSpec tasks, identify task groups or specs that have no dependencies between them and offer to execute them in parallel using concurrent agents. Always ask before parallelizing.

### Git Worktrees
This project uses git worktrees for parallel feature development. Each worktree is a separate working directory with its own branch, allowing simultaneous work on multiple features without context switching.

```bash
# List worktrees
git worktree list

# Create new worktree
git worktree add ../aurea-<feature> -b feat/<feature> HEAD

# Sync worktree to latest commit
cd ../aurea-<feature> && git reset --hard <commit>
```

Worktree naming convention: `aurea-<feature-name>` (e.g., `aurea-sidebar-media`).

See `openspec/docs/README-worktree.md` for detailed workflow documentation.

### Completion summary
After finishing all tasks for a change, produce a one-line-per-task summary of completed work suitable for an Odoo task board. Format: `- [capability] brief description of what was done`.

## OpenSpec Workflow

This project uses OpenSpec for structured change management. Default schema is `spec-driven` with artifact sequence: proposal → specs → design → tasks. Changes are tracked in `openspec/changes/`. Use `/opsx:*` slash commands (`new`, `continue`, `apply`, `verify`, `archive`) to drive the workflow. Detailed instructions are in `.claude/skills/openspec-*/SKILL.md`.
