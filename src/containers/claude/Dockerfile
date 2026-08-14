FROM almalinux:10-minimal

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

RUN useradd -m -s /bin/bash agent

ENV PATH="/home/agent/.local/bin:$PATH"
ENV NPM_CONFIG_PREFIX=/home/agent/.npm-global
ENV PATH="/home/agent/.npm-global/bin:/home/agent/node_modules/.bin:$PATH"

RUN mkdir -p             /home/agent/.npm-global /home/agent/.npm  && \
    chown -R agent:agent /home/agent/.npm-global /home/agent/.npm

USER agent
WORKDIR /home/agent

COPY --chown=agent:agent !config       /home/agent/.config
COPY --chown=agent:agent !claude       /home/agent/.claude
COPY --chown=agent:agent !claude.json  /home/agent/.claude.json

RUN curl -fsSL https://claude.ai/install.sh | bash -                           && \
    claude install stable                                                      && \
    npm install -g ccstatusline@latest                                         && \
    (claude plugin marketplace update claude-plugins-official       ||  true)  && \
    (claude plugin install code-simplifier@claude-plugins-official  ||  true)  && \
    npm cache clean --force
# Needs Claude login/credentials:
#    claude plugin marketplace update claude-plugins-official
#    claude plugin install code-simplifier@claude-plugins-official

USER root
WORKDIR /home/root
COPY --chown=root:root --chmod=755 bootstrap-hosts.sh /home/root/bootstrap-hosts.sh
ENTRYPOINT ["/home/root/bootstrap-hosts.sh"]
CMD        ["claude"]
