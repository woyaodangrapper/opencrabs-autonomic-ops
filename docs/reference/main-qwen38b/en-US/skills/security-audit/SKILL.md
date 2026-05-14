---
name: security-audit
description: "OCAO security and CVE audit scored 0-100. Detect project type, run native scanners, inspect diff/static risks, cite evidence."
---

# Security Audit

Keywords: OCAO, security, CVE, injection, auth, crypto, secrets, subprocess, network, score, Chinese output.

User-facing output must always be Chinese.

## Route

Use for concrete security review. Detect language and infrastructure first. Report only issues a security engineer would confidently raise. This is a complex/high-risk route when scanners, diffs, auth, secrets, network listeners, or infra are involved.

## Detect

Find manifests and dispatch native scanners:
- Rust: `cargo audit`.
- Node: package-manager audit.
- Python: `pip-audit` or `safety`.
- Go: `govulncheck`.
- Ruby/PHP/JVM/.NET/Swift/Dart/Elixir/Terraform/Docker: native scanner or `osv-scanner` fallback.

If scanner is missing, state it and continue static review.

## Review

Focus on exploitable patterns:
- Injection: SQL, command, path traversal, template, XML, LDAP/NoSQL.
- Auth/authz: missing protection on state changes, JWT/session misuse, IDOR, role bypass.
- Crypto/secrets: weak algorithms for security, hardcoded secrets, predictable RNG, custom crypto.
- Deserialization: unsafe loaders on untrusted input.
- Web: XSS sinks, CSRF, CORS misuse, cookie flags, open redirect, clickjacking headers.
- TLS/SSRF: disabled verification, user-controlled hosts/protocols, metadata/internal IP access.
- Subprocess: shell form, untrusted interpolation, inherited env/stdin/cwd, missing timeout.
- Files: secret file permissions, unsafe temp files, world/group writable outputs.
- Network: public binds, TLS versions, redirect policy, security headers.
- Infra: root containers, privileged mode, broad IAM/security groups, secrets in env/build.

Skip low-confidence theory, DOS-only issues, prompt injection, rate-limit gaps, log spoofing, and findings requiring already-compromised privileged access.

## Scope

Prefer `git diff main...HEAD`. If unavailable, inspect recent commits or full tree as requested. Always say what was examined and skipped.

## Score

Score 0-100, renormalizing non-applicable dimensions:
- input validation;
- auth/authz;
- crypto/secrets;
- subprocess/file perms;
- network surface;
- web hardening;
- dependencies;
- container/infra.

## Output

Markdown report:
- project types detected;
- stages run/skipped;
- score table;
- HIGH/MEDIUM findings only, each with file:line, severity, category, exploit path, fix;
- items examined and cleared;
- non-blocking hardening;
- what was not examined.

## Discipline

Confidence threshold for findings: 0.8+. Be terse and evidence-based. Do not pad the report. Do not claim a scanner result if the scanner did not run.
