# meld image

Edit following volume bind path.
- MELD_BIND_PATH

## App specific configuration
```yaml
  meld:
    build: https://github.com/ysuito/desktop-compose.git#master:src/meld
    image: meld
    container_name: meld
    depends_on:
      - ubuntubase
    volumes:
      - "MELD_BIND_PATH:/home/user"
    command: ["su user -c \\\"gedit\\\""]
```
