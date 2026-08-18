# AGENTS.md

Guidance for coding agents working in this repository.
See also `README.md` for human-readable description and feature intention.

## Project Shape

This project wraps several AI coding CLIs in Apple Containers. The main entrypoint is `src/agent-start`; the small scripts in `src/` such as `src/codex`, `src/claude`, `src/gemini`, `src/opencode`, `src/vibe`, `src/antigravity`, and `src/agy` source it with the desired agent name.

Container images live under `src/containers/<agent>/`. Each image installs a common Linux toolchain, creates an `agent` user, installs the relevant AI CLI, then uses `src/containers/bootstrap-hosts.sh` as the entrypoint so host aliases can be injected before the CLI runs.

`src/vm-refresh-ip` is a helper for updating a VM hostname in `/etc/hosts` after its IP changes. Treat it as adjacent tooling, not part of the main agent launch path.

## Editing Rules

- When you need to search docs, use `context7` tools.
- Keep shell scripts POSIX-ish Bash and consistent with the existing style: `#!/bin/bash`, `set -e`, uppercase configuration variables, and section headers.
- Do not bake credentials, sessions, or logs into Docker images. Runtime state should stay in host-mounted directories or be excluded by `Dockerfile.dockerignore`.
- Preserve the safety model in `src/agent-start`: restricted mounts outside whitelisted project paths, unsafe agent flags only inside `PROJECT_WHITELIST`, and explicit flags for SSH, localhost, and VM access.
- When adding an agent, update all of these together: wrapper script in `src/`, case handling in `src/agent-start`, container directory under `src/containers/`, and README supported-agent documentation.
- Keep Dockerfiles close to the existing pattern unless the agent needs something specific: AlmaLinux minimal base, common developer packages, Node.js 22, `agent` user, copied starter config, CLI installation, `bootstrap-hosts.sh` entrypoint.
- Avoid unrelated cleanup. This repository may contain local machine paths and personal runtime conventions by design.

## Verification

Useful checks after changes:

```bash
bash -n src/agent-start src/vm-refresh-ip src/containers/bootstrap-hosts.sh
for f in src/codex src/claude src/gemini src/opencode src/vibe src/antigravity src/agy; do bash -n "$f"; done
```

For Docker image changes, build the affected image from its directory or run:

```bash
cd src/containers
bash build-all.sh
```

Apple Container and `sudo`-requiring DNS/VM paths may not be available in all development environments, so document any verification that could not be run.
