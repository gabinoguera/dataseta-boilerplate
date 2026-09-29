---
name: issue-spec
description: Produce una spec técnica completa para un GitHub Issue. Explora el codebase, construye un documento de sesión vivo, y lo publica como comentario en el Issue. Ejecutar antes de /worktree-tdd.
argument-hint: <issue_number>
disable-model-invocation: true
---

<input>
$ARGUMENTS
</input>

# /issue-spec — Spec técnica para un Issue

Eres un arquitecto técnico. Tu trabajo es producir una especificación completa para el Issue indicado, y publicar ese documento como comentario en el Issue.

El input es el número de Issue (e.g. `42`).

---

## Fase 1 — Setup

1. Parsear `$ARGUMENTS` como número de Issue `N`
2. Obtener el Issue:
   ```bash
   gh issue view {N} --json number,title,state,body,comments,labels
   ```
3. `git fetch origin`
4. Leer `${CLAUDE_SKILL_DIR}/issue-spec-template.md`
5. Si ya existe `.claude/sessions/issue_spec_{N}.md`, usar AskUserQuestion:
   - "Ya existe una spec para el Issue #{N}. ¿Continuamos con la existente o la sobreescribimos?"

---

## Fase 2 — Exploración del codebase

Lanzar **2-3 Explore agents en paralelo** con focos específicos basados en el contenido del Issue:

- **Agent 1**: Identificar módulos, servicios y rutas relevantes (cruzar keywords del Issue con archivos y clases)
- **Agent 2**: Encontrar tests existentes relacionados, fixtures, y patrones de test a seguir
- **Agent 3** (si aplica): Explorar frontend, infraestructura, o integración AI según el Issue

Esperar que **todos** completen antes de continuar.

---

## Fase 3 — Selección de secciones técnicas

Basándote en el Issue y la exploración, determinar qué secciones del Technical Design son relevantes. Presentar al usuario via AskUserQuestion para confirmar.

**Esperar confirmación** antes de continuar.

---

## Fase 4 — Inicializar documento de sesión

1. Copiar la plantilla:
   ```bash
   cp ${CLAUDE_SKILL_DIR}/issue-spec-template.md .claude/sessions/issue_spec_{N}.md
   ```
2. Rellenar cabecera, Problem Statement, estado actual del sistema
3. Eliminar secciones no relevantes, dejar activas con `[PENDING]`

---

## Fase 5 — Rellenar secciones técnicas

Para cada sección activa, investigar el codebase y rellenar con detalle concreto:
- Nombres reales de clases, funciones, rutas de archivo
- Cambios específicos necesarios
- Código de ejemplo cuando clarifica el approach

Después, sintetizar:
- **Test Strategy**: qué testear, fixtures necesarios, qué mockear
- **Acceptance Criteria**: Given-When-Then para cada funcionalidad + TCs manuales

---

## Fase 6 — Consolidación

Rellenar secciones de síntesis:
1. **Executive Summary**
2. **MoSCoW table** (Must/Should/Could/Won't)
3. **Implementation Phases table** (granulares, un commit por fase, TDD flag, dependencias)
4. **UML Sequence Diagrams** (Mermaid, si hay flujos complejos)
5. **Appendix**: Files to Create / Files to Edit
6. **Success Criteria**: funcionales y no-funcionales

---

## Fase 7 — Review con usuario

Presentar MoSCoW + Implementation Phases via AskUserQuestion.
**Esperar confirmación** antes de publicar.

---

## Fase 8 — Publicar

1. Publicar como comentario:
   ```bash
   gh issue comment {N} --body-file .claude/sessions/issue_spec_{N}.md
   ```
2. Actualizar header: `Estado: draft` → `Estado: publicado`
3. **NO borrar** el archivo de sesión — es contexto para `/worktree-tdd`

---

## Reglas

- `AskUserQuestion` ANTES de comenzar (Fase 3) y ANTES de publicar (Fase 7)
- El archivo de sesión **nunca se borra**
- Siempre `--body-file` para comentarios GitHub
- MoSCoW e Implementation Phases son siempre obligatorios
