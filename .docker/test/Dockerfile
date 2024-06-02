FROM alpine:3.20.0

ARG SSH_PASSWORD
ENV SSH_PASSWORD=${SSH_PASSWORD}

RUN apk add --update --no-cache net-tools busybox-extras nano tree openssh bash ncurses;

RUN adduser -g cicd -g rootless -D cicd;

USER cicd
RUN ssh-keygen -t rsa -b 4096 -f /home/cicd/.ssh/id_rsa -N ""
RUN touch /home/cicd/.ssh/authorized_keys
RUN cat /home/cicd/.ssh/id_rsa.pub >> /home/cicd/.ssh/authorized_keys

USER root
RUN ssh-keygen -A

WORKDIR /home/cicd

RUN mkdir -p /home/cicd/bin
COPY --chmod=a-w+x --chown=cicd:cicd bin/ /home/cicd/bin
COPY --chmod=a-w+x --chown=cicd:cicd  .docker/test/scripts/* /usr/bin/

RUN passwd -u cicd

COPY --chmod=+x .env /app/

RUN mkdir -p /home/cicd/.ssh
RUN chown -R cicd:cicd /home/cicd
RUN chmod -R 700 /home/cicd/.ssh && chmod -R 600 /home/cicd/.ssh/*

USER cicd

ENTRYPOINT ["entrypoint.sh"]

CMD ["start.sh"]
