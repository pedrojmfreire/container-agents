FROM almalinux:10-minimal

ARG AGENT_USER
ARG AGENT_HOME


RUN microdnf -y update                                         && \
    microdnf -y install shadow-utils                           && \
    microdnf -y install git openssh-clients                    && \
	microdnf -y install grep sed gawk                          && \
	microdnf -y install curl rsync tar gzip unzip              && \
	microdnf -y install gcc-c++ make libxslt                   && \
	microdnf -y install net-tools whois nc                     && \
	microdnf -y install jq                                     && \
	microdnf -y install bubblewrap                             && \
	microdnf -y install epel-release                           && \
	microdnf -y install --enablerepo=epel yq                   && \
    curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -  && \
    microdnf -y install nodejs                                 && \
    microdnf clean all

	# Add tools required for your development,
	# that may need to be invoked by the agent

# TODO: Playwright support may need Ubuntu
#   npx playwright install-deps  && \
# or
#    microdnf -y install \
#   	libnspr4 \
#       libnss3 \
#       libatk1.0-0t64 \
#       libatk-bridge2.0-0t64\
#       libcups2t64 \
#       libxcb1 \
#       libasound2t64 \
#       libgbm1 \
#       libx11-6 \
#       libxext6 \
#       libcairo2 \
#       libpango-1.0-0 \
#       libxcomposite1 \
#       libxdamage1 \
#       libxfixes3 \
#       libxrandr2 \
#       libatspi2.0-0t64         && \
# Both fail as "libnspr4" is unknown; may need Ubuntu

RUN useradd -m -s /bin/bash -d "$AGENT_HOME" "$AGENT_USER"

# ENV PATH="$AGENT_HOME/.local/bin:$PATH"
ENV NPM_CONFIG_PREFIX="$AGENT_HOME/.npm-global"
ENV PATH="$AGENT_HOME/.npm-global/bin:$AGENT_HOME/node_modules/.bin:$PATH"

RUN mkdir -p                           $AGENT_HOME/.npm-global $AGENT_HOME/.npm  &&  \
    chown -R "$AGENT_USER:$AGENT_USER" $AGENT_HOME/.npm-global $AGENT_HOME/.npm

USER "$AGENT_USER"
WORKDIR "$AGENT_HOME"

COPY --chown="$AGENT_USER:$AGENT_USER"  "!codex"  "$AGENT_HOME/.codex"

RUN npm install -g @openai/codex           && \
    npm cache clean --force
# TODO: Implement Playwright support
#    npm install -g @playwright/cli@latest  && \
#    playwright-cli install                 && \
#    playwright-cli install-browser         && \

USER root
WORKDIR /home/root
COPY --chown=root:root --chmod=755 bootstrap-hosts.sh /home/root/bootstrap-hosts.sh
ENTRYPOINT ["/home/root/bootstrap-hosts.sh"]
CMD        ["codex"]
