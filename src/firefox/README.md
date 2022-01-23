# firefox image

Edit following volume bind path.
- FIREFOX_BIND_PATH

## App specific configuration
```yaml
  firefox:
    build: https://github.com/ysuito/desktop-compose.git#master:src/firefox
    image: firefox
    container_name: firefox
    depends_on:
      - ubuntubase
    shm_size: 2GB
    tmpfs: /dev/shm
    volumes:
      - "FIREFOX_BIND_PATH:/home/user"
    command: ["su user -c \\\"firefox --new-instance\\\""]
```
