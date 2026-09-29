---
name: block-push-main
enabled: true
event: bash
pattern: git\s+push\s+(origin\s+)?(main|master)\b
action: block
---

**Push directo a main/master bloqueado**

Nunca se debe hacer push directo a `main`. Usa feature branches + Pull Requests.
