FROM alpine:latest

WORKDIR /app

COPY --chmod=a-w+x --chown=cicd:cicd  .docker/app/scripts/* /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN echo "Building ..."
RUN sleep 2

CMD ["entrypoint.sh"]
