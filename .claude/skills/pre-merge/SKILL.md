---
name: pre-merge
description: Analiza la viabilidad de un merge entre ramas. Compara divergencia, detecta conflictos, genera checklist ordenado por criticidad con secuencia exacta de comandos.
argument-hint: <rama_origen> <rama_destino>
disable-model-invocation: true
---

<input>
$ARGUMENTS
</input>

# /pre-merge — Análisis de merge entre ramas

Eres un coordinador de releases. Tu trabajo es analizar un merge entre dos ramas, identificar riesgos, y presentar un checklist claro antes de ejecutar ningún comando destructivo.

El input son dos ramas: `<origen> <destino>`.

---

## Fase 1 — Setup

1. Parsear `$ARGUMENTS`: SOURCE_BRANCH + TARGET_BRANCH
2. `git fetch origin --prune`
3. Verificar que ambas ramas existen

---

## Fase 2 — Análisis de ramas

```bash
git log --oneline origin/{TARGET}..origin/{SOURCE}
git log --oneline origin/{SOURCE}..origin/{TARGET}
git diff --name-status origin/{TARGET}...origin/{SOURCE}
```

Determinar dirección de merge recomendada y detectar conflictos.

---

## Fase 3 — Análisis por dominio

Revisar el diff y analizar según lo que cambia:
- Base de datos: cambios de schema, migraciones, compatibilidad
- Backend: rutas de API, dependencias, variables de entorno
- Frontend: componentes compartidos, rutas
- Infra: Docker, CI/CD, deploy config

---

## Fase 4 — Consolidar checklist

Generar `.claude/sessions/pre_merge_{SOURCE}_{TARGET}.md` desde la plantilla.

Clasificar items: Bloqueante / Requerido post-merge / Recomendado / OK

---

## Fase 5 — Presentar al usuario

`AskUserQuestion` con resumen, bloqueantes, y secuencia de comandos.
Si hay bloqueantes: **NO ejecutar merge**.

---

## Cost optimization
Lanzar con Sonnet (`claude --model sonnet`) y `effort: "low"` — análisis de git es mecánico.

---

## Reglas

- **NUNCA ejecutar merge sin confirmación explícita**
- Si hay Bloqueantes → terminar sin mergear
- Archivo de sesión NO se borra
