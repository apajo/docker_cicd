# force rebuild
ARG CACHEBUST=1

FROM alpine:latest

# Install bash
RUN apk add --no-cache bash tree

WORKDIR /app

COPY --chmod=a-w+x --chown=cicd:cicd  .docker/app/scripts/* /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Ensure the /app/volume directory exists and has the correct permissions
RUN mkdir -p /app/volume
COPY README.md /app/volume/

RUN echo "Building ..."

CMD ["entrypoint.sh"]
