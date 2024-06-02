FROM docker:26.0.0-dind-rootless as dind-ssh

USER root

RUN apk update --no-cache;

# Install dependencies required for the rest of the installations
RUN apk add --no-cache \
    openssh \
    git \
    curl \
    bash \
    bash-completion \
    docker-cli-compose;

RUN apk add --update --no-cache net-tools busybox-extras nano tree moreutils parallel make ncurses;

# Install Docker Compose V2 as a Docker plugin
RUN mkdir -p ~/.docker/cli-plugins/ && \
    curl -SL "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose && \
    chmod +x ~/.docker/cli-plugins/docker-compose

# Set user CICD
RUN adduser -g cicd -g rootless -D cicd -D docker; \
    mkdir -p /home/cicd/.ssh; \
    touch /home/cicd/.ssh/authorized_keys; \
    touch /home/cicd/.ssh/know_hosts; \
    chown -R cicd:cicd /home/cicd; \
    chmod 700 /home/cicd/.ssh && chmod 600 /home/cicd/.ssh/authorized_keys

RUN passwd -u cicd; \
    ssh-keygen -A;

RUN mkdir -p /home/cicd/bin
COPY --chmod=a-w+x --chown=cicd:cicd bin/ /usr/local/bin
COPY --chmod=+x .docker/host/scripts/* /usr/bin/

COPY .docker/host/sshd/ /etc/ssh/

RUN touch /var/log/btmp

RUN if [ -n "${SSH_PASSWORD}" ]; then echo "cicd:${SSH_PASSWORD}" | chpasswd; fi

# Staging build step
FROM dind-ssh

ARG SSH_PASSWORD
ENV SSH_PASSWORD=${SSH_PASSWORD}

WORKDIR /home/cicd

# Create backup and build dirs
RUN mkdir -p /app/build; \
    mkdir -p /var/backups/digicmr; \
    chown -R cicd:cicd /app; \
    chown -R cicd:cicd /var/backups/digicmr;

# Create dir links to $HOME
RUN ln -s /app/build /home/cicd/build; \
    ln -s /var/backups/digicmr /home/cicd/backups;

# Staging specific scripts
COPY --chmod=a-w+x --chown=cicd:cicd .docker/host/bin/ /usr/local/bin

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["dockerd-entrypoint.sh"]