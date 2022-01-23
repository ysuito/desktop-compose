# gedit image

Edit following volume bind path.
- GEDIT_BIND_PATH

## App specific configuration
```yaml
  meld:
    build: https://github.com/ysuito/desktop-compose.git#master:src/gedit
    image: gedit
    container_name: gedit
    depends_on:
      - ubuntubase
    volumes:
      - "GEDIT_BIND_PATH:/home/user"
    command: ["su user -c \\\"gedit\\\""]
```
