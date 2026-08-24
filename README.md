# Container-Agents

_You can read more about the rationale behind this project in
Pedro Freire's blog post "[Safer & Faster: AI in an Apple Container](https://www.pedrofreire.com/blog/safer-faster-ai-in-apple-container.html)"_


Are you a proud macOS 26+ user on Apple Silicon wanting to run
[Apple Container](https://github.com/apple/container)
to sandbox your AI agents?
Then this project is for you.

Container-Agents is a macOS-native development environment for running multiple coding agents autonomously while
preserving the developer's existing workflow—including local VMs and controlled remote-server access.

Container-Agents gives each coding agent its own disposable Linux workspace
**while still feeling identical to your normal terminal workflow**.
Prior to using this project you'd launch Claude Code with:

```bash
cd project
claude
```

After this project is installed, you launch Claude Code with:

```bash
cd project
claude
```

Two major advantages in the second launch, though:
- Claude Code will **only** have access to files and directories inside `project`,
  under the exact same absolute path.
- If "project" is a configured project directory, Claude Code runs with
  `--dangerously-skip-permissions` and therefore asks no permissions before
  making changes to files.

Safer. Faster.


### Safety Model

This project assumes coding agents are useful enough to deserve real tools, and
powerful enough to deserve boundaries.

By default, the current directory is the only project mount, using the exact same
absolute path in the container, as the host.
As a precaution, if the current directory is your home (`~`) or main documents root
(`~/Documents`), the script will ask you if you're really trying to share
all your documents with the agent.

Inside trusted project paths, agents get their normal autonomous flags
(e.g., `--dangerously-skip-permissions`) because that is where you
expect them to work. Host-localhost access and VM access are opt-in.
Per-agent-SSH is opt-in per invocation.
Images are disposable, but the agent's configuration and state is persisted
across invocations via explicit mounts.

That combination removes hesitation from an AI workflow:
agents can do serious engineering work without getting a free pass to your whole Mac.


### MCP Servers and Plugins

Container-Agents supports the MCP configuration and plugins you prefer:
just be sure to edit the sample `Dockerfile` for your agent, to ensure
your favorite setup is pre-installed on the container.

You can also have the container talk to MCP servers hosted on the Internet,
as usual, or to MCP servers running on the local host.


### Local AI Models

You could install a platform for running local LLMs (Ollama, LM Studio, MTPLX)
inside the container, but the fixed memory limit of a container isn't well
suited for a large memory footprint service such as an LLM platform.

Container-Agents supports connecting its agents to LLM platforms running
in the local host. Learn more about option `---local`.


### Development and Staging

Container-Agents (optionally) supports connecting its agents to virtual machines running on
the local host, and to map agent-specific SSH configuration with the container.
Learn more about options `---vm` and `---ssh`.


## Why Container-Agents?

What stands out in Container-Agents is it's opinionated nature about disappearing underneath the developer's existing
environment. You type `claude`; your IDE passes the same absolute paths; your existing VM hostnames still work;
your existing servers remain accessible under deliberately constrained identities.

Find a quick comparison below.

| Capability                            | Container-Agents                                                                                  | [Docker Sandboxes](https://www.docker.com/products/docker-sandboxes/)                                             | [Zigotica's Agent Sandbox](https://github.com/zigotica/agent-sandbox)          | [Mattolson's Agent Sandbox](https://github.com/mattolson/agent-sandbox)        |
|---------------------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| Autonomous coding agents              | Designed for autonomous coding CLIs, with unsafe flags enabled only inside trusted project paths. | Possible, but usually assembled per project or per CLI.                                                           | Focused on sandboxing an agent workflow; agent support depends on its harness. | Focused on agent sandboxing; agent support depends on its configured workflow. |
| Multiple agent harnesses              | Built around wrapper scripts for Codex, Claude Code, Gemini, Antigravity, Vibe, and OpenCode.     | Usually one-off images or compose files unless you build a shared launcher layer.                                 | Primarily one sandbox harness.                                                 | Primarily one sandbox harness.                                                 |
| Strong VM isolation                   | Uses Apple Container, which runs Linux containers inside Apple's lightweight VM isolation model.  | Docker Desktop also uses a Linux VM on macOS, but behavior depends on Docker's file sharing and networking model. | Docker-based isolation.                                                        | Docker-based isolation.                                                        |
| Only expose project                   | ✓                                                                                                | Commonly possible with bind mounts, but depends on each setup.                                                    | Project exposure depends on how the sandbox is launched.                       | Project exposure depends on how the sandbox is launched.                       |
| Current directory by default          | ✓                                                                                                | Possible, but typically requires custom scripts or aliases.                                                       | Depends on the harness invocation.                                             | Depends on the harness invocation.                                             |
| Preserve identical absolute host path | ✓                                                                                                | Usually not by default; many setups mount to `/workspace` or another container-only path.                         | Typically uses a container workspace path.                                     | Typically uses a container workspace path.                                     |
| Host-local services                   | ✓                                                                                                | Possible through Docker host networking conventions, with platform-specific caveats.                              | Depends on Docker networking configuration.                                    | Depends on Docker networking configuration.                                    |
| Network access policies               | Explicit flags control localhost, VM access, SSH material, and raw/safe agent startup.            | Docker network policy is flexible, but usually left to the caller to define.                                      | Depends on the sandbox configuration.                                          | Depends on the sandbox configuration.                                          |
| Local development VM integration      | ✓                                                                                                | Possible manually with Docker networking or host tunnels.                                                         | Not a primary feature.                                                         | Not a primary feature.                                                         |
| Per-agent SSH identities              | ✓                                                                                                | Possible manually, but not usually a built-in convention.                                                         | Depends on configuration.                                                      | Depends on configuration.                                                      |
| Remote-server agent attribution       | ✓                                                                                                | Possible if you create separate keys and mount them carefully.                                                    | Depends on configured SSH identity handling.                                   | Depends on configured SSH identity handling.                                   |
| Trusted-directory -> autonomous mode  | ✓                                                                                                | Usually manual per invocation.                                                                                    | Depends on the harness policy.                                                 | Depends on the harness policy.                                                 |
| Native Apple Containers               | ✓                                                                                                | No                                                                                                                | No                                                                             | No                                                                             |
| Cross-platform                        | No                                                                                                | ✓                                                                                                                | ✓                                                                             | ✓                                                                             |



## Quick Start

### Requirements

- macOS with [Apple Container](https://github.com/apple/container) installed and working.
- Enough local resources for the default container run settings:
  `--cpus 2 --memory 2G`.
- Agent credentials or login state for whichever CLI you want to use.
- `sudo` access for Apple Container DNS helpers and VM tunnel helpers.


### Installation

Build the images:

```bash
cd src/containers
bash build-all.sh
```

Make the launchers easy to call.
Copy/symlink all `src/*` Bash scripts to a location in your `PATH`
and enable their executable permission.

```bash
chmod a+x src/*
export PATH="$PWD/src:$PATH"
```

From any project directory, start an agent:

```bash
codex
claude
antigravity
agy
gemini
vibe
opencode
```

Be sure to run your agents with `---link` to soft-link the
`src/containers/<agent>/!*` directories and files to their proper
`~/.config` and `~/.local`, etc., locations.

The wrappers are tiny scripts that all delegate to `src/agent-start`. You can
also call the main launcher directly:

```bash
agent-start ---agent=codex
```


### Configuration

The defaults live near the top of `src/agent-start`, but local machine settings
can be overridden with `~/dev-env.sh`. This repository includes `dev-env.sh` as a
template that you can copy to that location:

```bash
DEV_ENV_PROJECT_DIRS=(
    "$HOME/Documents/Software"
)

# Base directory for container settings
# Note: This should be an absolute path! Replace before running!
DEV_ENV_CONTAINERS_DIR="./src/containers"

DEV_ENV_LOCALHOST_DNS_ALIAS=host.container.internal
DEV_ENV_LOCALHOST_IP_ALIAS=203.0.113.113

DEV_ENV_VM_USER=user
DEV_ENV_VM_HOST=vm.local
DEV_ENV_VM_PORTS=(22 80 443)
```

The most important setting is `PROJECT_DIRS`/`DEV_ENV_PROJECT_DIRS`.
When your current directory is inside one of those paths, `agent-start` considers it trusted and
enables the  agent's unsafe or fully-autonomous flags. **Outside those paths, only the current
directory is mounted at `<agent-home>/workspace`, and the unsafe flags are not
added**.

Runtime CLI configuration is mounted per agent in `src/agent-start`. Adjust those
volume paths to match where you keep each agent's config, auth, and session
state. The checked-in `Dockerfile.dockerignore` files intentionally exclude
logs, caches, histories, sessions, and auth databases so they do not become part
of built images.


## Daily Usage

Run from the project you want the agent to edit:

```bash
cd ~/Documents/Software/my-project
codex
```

Pass normal CLI arguments to the agent:

```bash
codex "explain this repository"
claude "run the tests and fix the first failure"
```

Use `---` when you want to stop processing further arguments and pass the remaining ones to the agent,
unchanged. This is optional: if `ALLOW_TRIPLE_DASH_OPTS_ONLY` is `true` (default), all arguments
recognized by the `agent-start` wrapper start with `---`, and any arguments not recognized will be
passed to the agent.

Show all launch options:

```bash
codex ---help
```

```
Usage:
    opencode [<options>, ...]

Options:
  ---agent=<agent>  Select the agent to use (mandatory). 
                    Supported agents: claude, codex, antigravity, agy, gemini, vibe, opencode.
  ---all            Map all project dirs ($PROJECT_DIRS) to allow the agent to work across
                    projects. 
  ---sh             Run the container shell, not the agent itself. 
                    Must be defined after ---agent.
  ---ssh            Map ~/.ssh/* files to allow the agent to access to servers/Virtual Machines. 
  ---local          Create a container DNS 'host.container.internal' that maps to the host's localhost,
                    via 203.0.113.113. Required to access Ollama, LM Studio, MTPLX models,
                    VMs, or other services running on the host. This DNS entry is persistent across
                    all future invocations of agents, until a reboot. Environment vars
                    LOCALHOST_DNS_ALIAS and LOCALHOST_IP_ALIAS are passed to the agent for reuse.
                    This is incompatible with iCloud Private Relay. 
  ---local-del      Delete DNS entry created by ---local, and exit. 
  ---vm             Setup SSH tunnels to allow the agent to access a host VM ('user@vm.local')
                    using Shared Network. Not required for Bridged Network.
                    This SSH tunnel is persistent across all future invocations of agents, until
                    the VM shuts down. Implies ---local.
                    This is incompatible with services running in the host in the same ports
                    (22 80 443). 
  ---vm-del         Close the SSH tunnel created by ---vm, and exit. Does not do a ---local-del. 
  ---connect        Combined ---ssh, ---local and ---vm. 
  ---link           Link './src/containers/<agent>/!*'
                    to ~/.config, ~/.local, etc. and exit. 
  ---unlink         Unlink './src/containers/<agent>/!*'
                    from ~/.config, ~/.local, etc. and exit. 
  ---safe           Do not pass any '--dangerously-skip-permissions'-type options to the agent.
                    Must be defined after ---agent. 
  ---raw            Do not pass any implicit options or environment to the agent at all.
                    Must be defined after ---agent.
  ---help           This help. 

All ---local, ---vm also create DNS aliases inside the container, that match host /etc/hosts DNS
aliases pointing to 127.0.0.1 or the VM's 'vm.local' IP. All DNS aliases inside the container will
point to 203.0.113.113. This ensures they match functionality on the host and container.

Pass options to the agent:
  --- <agent-options>  Stop processing the next options and pass them to the agent.
```


## Features

- **Runs popular AI coding CLIs in Apple Containers**:
    - OpenAI Codex / ChatGPT CLI
    - Claude Code
    - Google Gemini CLI
    - Google Antigravity CLI
    - Mistral Vibe
    - OpenCode
- Mounts only the current directory by default.
- **Enables full agent permissions only inside trusted project directories**.
- Optionally mounts all configured project roots so agents can work across
  related repositories.
- Shares a single AI skills directory ($AI_SKILLS_DIR) across all agents
  (**BETA**: this shares only the directory, doesn't change the format;
  set $AI_SKILLS_DIR empty to disable)
- Optionally mounts **agent-specific SSH keys and known hosts**.
- Optionally exposes host `localhost` to containers through a stable DNS alias,
  useful for Ollama, LM Studio, local model servers, web apps, databases, and
  other development services.
- Optionally creates SSH tunnels to a host VM — required for VM "Shared Networking"
- Automatic support for ACP via auto-detection of TTY.
- Keeps runtime auth/session/log state out of images; the images contain tools
  and starter config, while state is persisted across invocations via mounts.
- Soft-links persisted state to their expected locations in `~`.
- Uses small wrapper scripts, so daily use can be as simple as `codex` from the
  directory you already work in.


### Agent Username+Home Matching Host

Each agent's `Dockerfile` creates a specific OS user for the agent to run under.
This user has the same name and home directory as the user you're running under
in macOS -- thereby ensuring matching absolute paths between host and container,
making it easier to share configuration and files between both.


### Accessing the Host's localhost

Apple Containers launches each container in a virtual network segment separate from
the host's `localhost`. No default routing exists between the two.

Apple
[provides a solution](https://github.com/apple/container/blob/main/docs/host-integration.md#access-a-host-service-from-a-container),
though. `---local` creates an Apple Container DNS entry so the container can reach a host
service through `host.container.internal`. This is useful for local LLM model
servers, web apps, databases, and API mocks.

Localhost aliasing is optional because it is incompatible with
iCloud Private Relay.


### Virtual Machine Access

Virtual Machines (VMs) can be configured with both Shared or Bridged Network.
With Apple Virtualization, Shared Network has the advantage that if you take
your laptop to a location that has no network access, your host system can
still network with the local VM. Bridged Network cannot — at least not easily.

However, Shared Networking brings a new hurdle: Apple creates the IP for the
VM under a separate virtual network segment from Apple Containers. No default
routing exists between the two.

To enable this communication, Container-Agents has the `---vm` option which
creates SSH port forwards from the host to a configured VM. Using this option
also enables `---local` so the container can reach the host's `localhost` network.


### /etc/hosts

Custom DNS hosts defined in `/etc/hosts` of the host system are common in
developer systems. They point either to locally-running services
(LLMs, MCPs, databases), or to VM services.

When using either `---local` or `---vm`, all relevant `/etc/hosts` names are copied
to the container system, with all of them pointing to
`LOCALHOST_IP_ALIAS`/`DEV_ENV_LOCALHOST_IP_ALIAS`. This ensures those names
are seamlessly available to the agent, as if it were running on the host.

`src/vm-refresh-ip` can help update `/etc/hosts` when a VM keeps the same SSH
host key but receives a new IP address.


### SSH Access with Auditing Support

`---ssh` mounts agent-specific SSH material into the container. The current
convention expects files like:

```text
~/.ssh/ssh-agent-codex.pem
~/.ssh/ssh-agent-codex.pem.pub
~/.ssh/config-agent-codex
~/.ssh/known_hosts_agents
```

Each agent has its own key/config name. This keeps an agent's server access
separate from your normal host SSH setup and makes it easier to revoke or rotate.
It also ensures all agent actions on the server(s) are traceable.


### Configuration Sharing with Host Agents

Some IDEs (e.g.: Visual Studio Code, JetBrains' IDEs) may install local copies
of your agents.
To have the configuration of such agents in sync with their container version,
while you experiment, you can invoke each agent with `---link` to soft-link the
agent-relevant `~/.config`, `~/.local`, etc., files to the main
`src/containers/<agent>/!*` locations.


### ACP Support

Use this sample JSON with JetBrains' IDEs to invoke OpenCode in a container:

```json
{ "default_mcp_settings": {},
  "agent_servers": {
    "OpenCode in container": {
      "command":"/<path-to->/opencode",
      "args": ["---safe", "acp"]
    }
  }
}
```


## Sample Container Images

Found in `src/containers`.


### Image Layout

Each container image follows the same broad structure:

- `almalinux:10-minimal` base image.
- Common development tools such as Git, OpenSSH client, curl, rsync, tar, gzip,
  unzip, compiler tooling, `jq`, `yq`, `nc`, and Node.js 22.
- An unprivileged user.
- Agent-specific starter config copied into that unprivileged user's home.
- Agent-specific runtime config mapped from `!*` files and directories — their
  standard leading dot (`~/.*`) replaced with `!` to make it easily visible and
  editable in macOS Finder.
- The selected AI CLI installed during image build.
- `bootstrap-hosts.sh` as the entrypoint, which appends host aliases and then
  drops privileges to the unprivileged user before running the CLI.

To add tools that your agents commonly need, edit the relevant Dockerfile under
`src/containers/<agent>/Dockerfile` and rebuild that image.


### Adding Another Agent

1. Add `src/containers/<agent>/Dockerfile` and `build.sh`.
2. Add starter config under `src/containers/<agent>/`, excluding runtime secrets
   in `Dockerfile.dockerignore`.
3. Add a wrapper script in `src/`.
4. Add a case to `src/agent-start` with the container image name, environment
   variables, executable, safe arguments, and unsafe arguments.
5. Add a container-run block with any agent-specific config and SSH mounts.
6. Rebuild and test with `---sh` before running the agent normally.

## Author & License

Author:  [Pedro Freire](http://www.pedrofreire.com)

License: [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt)
