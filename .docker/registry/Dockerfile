FROM registry:2.8

WORKDIR /root

RUN apk update --no-cache;

# Install python/pip
RUN apk add --no-cache py-pip py-setuptools

# General tools
RUN apk add --no-cache net-tools busybox-extras nano tree git bash;

# registry-cli
RUN git clone https://github.com/andrey-pohilko/registry-cli.git ./registry-cli
RUN chmod +x /root/registry-cli/registry.py
RUN ln -s /root/registry-cli/registry.py /usr/local/bin/registry.py

RUN pip install -r /root/registry-cli/requirements-build.txt

COPY --chmod=+x scripts/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/entrypoint.sh", "/etc/docker/registry/config.yml"]