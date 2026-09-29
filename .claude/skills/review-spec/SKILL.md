---
name: review-spec
description: Compara la spec técnica publicada en el Issue contra lo implementado en el PR. Detecta desviaciones (scope creep, missing, approach change), escala decisiones al usuario, y publica el veredicto antes de QA.
argument-hint: <issue_number>
disable-model-invocation: true
---

<input>
$ARGUMENTS
</input>

# /review-spec — Spec vs Implementación

Eres un revisor técnico. Tu trabajo es comparar lo planificado (spec del Issue) contra lo implementado (PR diff), detectar desviaciones, escalar las que requieren decisión, y emitir un veredicto antes de QA.

El input es el número de Issue `N`.

---

## Fase 1 — Setup

1. Obtener Issue con comentarios:
   ```bash
   gh issue view {N} --json number,title,body,comments --jq '.'
   ```
2. Identificar la spec (comentario con `# Issue Spec:`)
3. Obtener PR asociado y su diff:
   ```bash
   gh pr list --json number,title,headRefName,url
   gh pr diff {PR_NUMBER}
   gh pr view {PR_NUMBER} --json files
   ```
4. Si existe `.claude/sessions/issue_spec_{N}.md`, usarlo como fuente adicional.

---

## Fase 2 — Comparativa Implementation Phases

Para cada fase de la spec, clasificar:
- ✅ **OK** — evidencia clara, enfoque coincide
- ⚠️ **Approach Change** — implementado diferente
- ❌ **Missing** — sin evidencia
- 🔒 **Descoped** — excluido (Won't del MoSCoW)

---

## Fase 3 — Comparativa MoSCoW Must

Para cada Must: ✅ Cubierto / ❌ Sin evidencia / ⚠️ Parcial

---

## Fase 4 — Detectar Scope Creep

Archivos en el diff que no están en el Appendix de la spec (excluir tests y migraciones).

---

## Fase 5 — Clasificar y escalar desviaciones

| Tipo | Acción |
|------|--------|
| Scope Creep relevante | Escalar: `AskUserQuestion` |
| Missing bloqueante (Must) | Escalar: `AskUserQuestion` |
| Missing no bloqueante | Documentar |
| Approach Change OK | Documentar |
| Approach Change dudoso | Escalar: `AskUserQuestion` |

**Esperar respuesta** para cada desviación antes del veredicto.

---

## Fase 6 — Emitir veredicto y publicar

Construir `.claude/sessions/review_spec_{N}.md` desde la plantilla.

**Veredicto:**
- ✅ **Apto para QA**
- ⚠️ **Apto para QA con notas**
- ❌ **Bloqueado para QA**

Publicar:
```bash
gh issue comment {N} --body-file .claude/sessions/review_spec_{N}.md
```

---

## Reglas

- `AskUserQuestion` SOLO para decisiones de producto
- Si veredicto ❌ → NO continuar a QA
- `review_spec_{N}.md` **no se borra**
- Siempre `--body-file` para comentarios GitHub
- Tests y migraciones no cuentan como scope creep
- Sin spec publicada → comparar contra el body del Issue
