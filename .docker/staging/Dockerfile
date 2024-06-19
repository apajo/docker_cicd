FROM docker:26.0.0-dind as dind-ssh

ARG SSH_PASSWORD

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

RUN apk add --update --no-cache net-tools busybox-extras nano tree moreutils parallel make ncurses shadow;

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
    chmod 700 /home/cicd/.ssh && chmod 400 /home/cicd/.ssh/authorized_keys && \
    usermod -p '*' -s /bin/bash cicd

RUN passwd -u cicd; \
    ssh-keygen -A;

RUN mkdir -p /home/cicd/bin
COPY --chmod=a-w+x --chown=cicd:cicd bin/ /usr/local/bin
COPY --chmod=+x .docker/staging/scripts/* /usr/bin/

COPY .docker/staging/docker/ /etc/docker/

COPY .docker/staging/sshd/ /etc/ssh/
COPY .docker/staging/sshd/banner/staging /etc/ssh/banner
COPY .docker/staging/sshd/banner/staging /etc/motd

RUN touch /var/log/btmp

RUN if [ -n "${SSH_PASSWORD}" ]; then echo "cicd:${SSH_PASSWORD}" | chpasswd; fi

# Staging build step
FROM dind-ssh

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
COPY --chmod=a-w+x --chown=cicd:cicd .docker/staging/bin/ /usr/local/bin

ENTRYPOINT ["/usr/bin/entrypoint.sh"]