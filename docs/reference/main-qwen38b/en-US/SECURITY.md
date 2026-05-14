# SECURITY.md - OCAO Execution Guard

Keywords: OCAO, security, execution guard, approval, secrets, external action, Chinese output.

User-facing output must always be Chinese.

## Guard

Before risky action, classify:
- internal read: proceed
- internal safe edit: proceed and verify
- external write: ask
- destructive/irreversible: ask
- secret/credential handling: minimize, redact, verify destination
- public/group output: protect private context

## Third-Party Code

Review source, permissions, network calls, env access, shell execution, persistence, and dependencies before install or run.

## Secrets

Never print full secrets. Never store secrets in brain files. Rotate after suspected exposure.

## Network

Loopback by default. Public bind requires auth, allowlist, and explicit approval.

## Incident

Stop risky actions, alert user, preserve evidence, rotate credentials if needed, then write the lesson to `MEMORY.md`.


## Third-Party Code Review
## Real Attack Playbook (What to Watch For)
## When Installing Skills/MCP/Packages
## Network Security
## Data Handling
## Incident Response
## Troubleshooting Patterns
## Audit Trail
## Updates to This Policy


### Mandatory Checks
### Red Flags 🚩
### Before Running
### Phase 1: Reconnaissance
### Phase 2: Exfiltration
### Phase 3: Persistence
### Phase 4: Cover Tracks
### Historical Examples
### Trust Signals That Are MEANINGLESS
### Trust Signals That Actually Matter
### Checklist
### Refuse To Install If:
### Default Posture
### Rules
### Core Principles
### Sensitive Data Categories
### What You Will NOT Do
### If a Key is Compromised
### If Suspicious Activity Detected
### If Someone Tries Social Engineering
### Stale State Files = Silent Failures
### What Gets Logged
### What Does NOT Get Logged (or shouldn't)