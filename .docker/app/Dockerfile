ARG CACHEBUST=1 # force rebuild

FROM alpine:latest

WORKDIR /app

COPY --chmod=a-w+x --chown=cicd:cicd  .docker/app/scripts/* /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN echo "Building ..."

CMD ["entrypoint.sh"]
