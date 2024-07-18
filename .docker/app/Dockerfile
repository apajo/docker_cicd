# force rebuild
ARG CACHEBUST=1

FROM alpine:latest

WORKDIR /app

COPY --chmod=a-w+x --chown=cicd:cicd  .docker/app/scripts/* /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

COPY README.md /app/volume/
RUN ls -la /app/volume && exit 1;

RUN echo "Building ..."

CMD ["entrypoint.sh"]
