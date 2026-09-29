---
name: warn-sensitive-files
enabled: true
event: file
action: warn
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env$|\.env\.|credentials|secrets|\.pem$|\.key$
---

**Archivo sensible detectado**

- No hardcodees credenciales — usa variables de entorno
- Verifica que este en `.gitignore`
- Los archivos `.env` NUNCA se commitean
