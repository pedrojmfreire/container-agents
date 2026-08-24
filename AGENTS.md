# Container-Agents

Container-Agents gives each coding agent its own disposable Linux workspace while each agent's invocation still feels
identical to their normal terminal workflow.

See also `README.md` for human-readable description and feature intention.


## Folder Structure

```plaintext
/container-agents
│
├── /src                            # Project source files.
│   ├── /containers                 # Agents container configuration.
│   │   ├── <agent-name>            # Agent container configuration.
│   │   │   ├── <!* directories>    # Agent configuration directories, mapped to their container.
│   │   │   │                       # In this project, all these directories are empty.
│   │   │   ├── build.sh            # Bash script to build the container.
│   │   │   ├── Dockerfile          # Container setup instructions.
│   │   │   └── Dockerfile.dockerignore  # File+directory exclusions for building.
│   │   ├── bootstrap-hosts.sh      # Copied to each built container, this script appends records to the container's
│   │   │                           # /etc/hosts on each invocation.
│   │   └── build-all.sh            # Iterate through all sub-directories and invoke their build.sh.
│   ├── agent-start                 # Main agent start bash script. Usually not invoked directly.
│   ├── agy                         # Bash script that calls agent-start to start Google Antigravity.
│   ├── antigravity                 # Bash script that calls agent-start to start Google Antigravity.
│   ├── claude                      # Bash script that calls agent-start to start Anthropic's Claude Code.
│   ├── codex                       # Bash script that calls agent-start to start OpenAI's Codex.
│   ├── gemini                      # Bash script that calls agent-start to start Google Gemini (deprecated).
│   ├── opencode                    # Bash script that calls agent-start to start OpenCode.
│   ├── vibe                        # Bash script that calls agent-start to start Mistral Vibe.
│   └── vm-refresh-ip               # Bash script to auto-detect local IP changes on a locally running VM,
│                                   # and change /etc/hosts accordingly. VM identified in dev-env.sh.
│                                   # Treat this as adjacent tooling, not part of the main agent launch path.
│
├── AGENTS.md                       # This file
├── CLAUDE.md                       # Context file for Claude Code - simply refers to AGENTS.md
├── dev-env.sh                      # Sample global config file to be copied to ~/ by the user
├── GEMINI.md                       # Context file for Google Gemini - simply refers to AGENTS.md
├── LICENSE                         # License file -- Apache 2.0
└── README.md                       # Human-readable project introduction
```

`agy`, `claude`, `codex`, etc., wrapper scripts alleviate the need of adding to the memory footprint of your current
shell by adding yet another `alias`.


## Editing Rules

- Keep shell scripts POSIX-ish Bash, but 100% compatible with macOS and consistent with the existing style:
  `#!/bin/bash`, `set -e`, uppercase configuration variables, and section headers.
- Runtime state should stay in host-mounted directories.
- Do not bake credentials, sessions, or logs into Docker images.
- Preserve the safety model in `src/agent-start`: restricted mounts outside whitelisted project paths, unsafe agent
  flags only inside `PROJECT_WHITELIST`, and explicit flags for SSH, localhost, and VM access.
- When adding an agent, update all of these together: wrapper script in `src/`, case handling in `src/agent-start`,
  container directory under `src/containers/`, and `README.md` supported-agent documentation.
- Keep Dockerfiles close to the existing pattern unless the agent needs something specific: AlmaLinux minimal base,
  common developer packages, Node.js 22, `agent` user, copied starter config, CLI installation, `bootstrap-hosts.sh`
  entrypoint.


## Verification

Useful checks after changes:

- `bash -n` all modified scripts.
- Build modified containers, if possible.

Apple Container and `sudo`-requiring DNS/VM paths may not be available in all development environments, so document any
verification that could not be run.
