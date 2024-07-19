# 🐳 Docker CI/CD

## Troubleshooting

### Test DNS resolution inside staging container

```shell
docker compose exec -it staging bash -c "docker run --rm busybox nslookup neti.ee"
```
### Test simple docker image run 

```shell
docker compose exec -it staging bash -c "docker run --rm -it alpine sh"
```



### failed to create shim task: OCI runtime create failed: runc create failed: systemd not running on this host, cannot use systemd cgroups manager:

Verify that the filesystems are compatible between the host and the containers

```shell
cat /etc/docker/daemon.json; \
docker info | grep -i cgroup; \
docker compose exec -it staging bash -c "cat /etc/docker/daemon.json"; \
docker compose exec -it staging bash -c "docker info | grep -i cgroup";
```

## Helpers / shortcuts

All Images:
```shell
wget -O - http://localhost:5000/v2/_catalog
```

All Tags:
```shell
# Get the list of all images
IMAGES=$(wget -qO- http://localhost:5000/v2/_catalog | jq -r '.repositories[]')

# Loop through each image and get the tags
for IMAGE in $IMAGES; do
  echo "Tags for $IMAGE:"
  wget -qO- http://localhost:5000/v2/$IMAGE/tags/list | jq -r '.tags[]'
done
```


#### Enter interactive shell

```shell
docker compose exec -it --user cicd staging bash
```

#### Get public key from the container

```shell
docker compose exec -it --user cicd staging bash -c "cat ~/.ssh/id_rsa.pub"
```

#### Add your/host public key to authorized keys in the container

```shell
PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub); \
docker compose exec -it --user cicd host bash -c "echo $PUBLIC_KEY >> ~/.ssh/authorized_keys"
```

#### Add a domain to known hosts

```shell
read -p "Enter the domain: " DOMAIN; \
docker compose exec -it --user cicd staging bash -c "ssh-keyscan $DOMAIN >> ~/.ssh/known_hosts"
```

#### Clear containers:

```bash
docker stop $(docker ps -a -q); \
docker rm $(docker ps -a -q);
```

#### Setup Docker registry

```bash
docker run -d -p 5000:5000 --name local-registry registry:2
```
