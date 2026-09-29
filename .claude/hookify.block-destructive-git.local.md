---
name: block-destructive-git
enabled: true
event: bash
pattern: git\s+(push\s+--force|push\s+-f\s|reset\s+--hard|clean\s+-fd|checkout\s+--\s+\.|restore\s+--staged\s+\.|branch\s+-D)
action: block
---

**Operacion git destructiva bloqueada**

Comandos como `git push --force`, `git reset --hard`, `git clean -fd`, `git branch -D` pueden causar perdida de datos irreversible.

**Alternativas seguras:**
- `git stash` en lugar de `git reset --hard`
- `git push --force-with-lease` si realmente necesitas forzar
- Elimina archivos individuales en lugar de `git clean -fd`
