# kdenlive image

Edit following volume bind path.
- KDENLIVE_BIND_PATH

## App specific configuration
```yaml
  kdenlive:
    build: https://github.com/ysuito/desktop-compose.git#master:src/kdenlive
    image: kdenlive
    container_name: kdenlive
    depends_on:
      - ubuntubase
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    volumes:
      - "KDENLIVE_BIND_PATH:/home/user"
    command: ["su user -c \\\"kdenlive\\\""]
```
