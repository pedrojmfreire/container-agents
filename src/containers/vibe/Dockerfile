FROM almalinux:10-minimal AS base

ARG AGENT_USER
ARG AGENT_HOME


RUN microdnf -y update                                         && \
    microdnf -y install shadow-utils procps-ng                 && \
    microdnf -y install git openssh-clients                    && \
	microdnf -y install grep sed gawk                          && \
	microdnf -y install curl rsync tar gzip unzip              && \
	microdnf -y install gcc-c++ make libxslt                   && \
	microdnf -y install net-tools bind-utils whois nc          && \
	microdnf -y install jq sqlite                              && \
	microdnf -y install bubblewrap                             && \
	microdnf -y install epel-release                           && \
	microdnf -y install --enablerepo=epel yq                   && \
    curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -  && \
    microdnf -y install nodejs                                 && \
    microdnf clean all
    # NodeJS required for "npx" command for MCP servers

	# Add tools required for your development,
	# that may need to be invoked by the agent

RUN useradd -m -s /bin/bash -d "$AGENT_HOME" "$AGENT_USER"

ENV PATH="$AGENT_HOME/.local/bin:$PATH"
ENV NPM_CONFIG_PREFIX="$AGENT_HOME/.npm-global"
ENV PATH="$AGENT_HOME/.npm-global/bin:$AGENT_HOME/node_modules/.bin:$PATH"

RUN mkdir -p                           $AGENT_HOME/.npm-global $AGENT_HOME/.npm  &&  \
    chown -R "$AGENT_USER:$AGENT_USER" $AGENT_HOME/.npm-global $AGENT_HOME/.npm

USER "$AGENT_USER"
WORKDIR "$AGENT_HOME"

COPY --chown="$AGENT_USER:$AGENT_USER"  "!vibe"  "$AGENT_HOME/.vibe"

RUN curl -LsSf https://mistral.ai/vibe/install.sh | bash -  && \
    npm cache clean --force

USER root
WORKDIR /home/root
COPY --chown=root:root --chmod=755 bootstrap-hosts.sh /home/root/bootstrap-hosts.sh
ENTRYPOINT ["/home/root/bootstrap-hosts.sh"]
CMD        ["vibe"]
