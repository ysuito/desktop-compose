# freecad image

Edit following volume bind path.
- FREECAD_BIND_PATH

## App specific configuration
```yaml
  freecad:
    build: https://github.com/ysuito/desktop-compose.git#master:src/freecad
    image: freecad
    container_name: freecad
    depends_on:
      - ubuntubase
    volumes:
      - "FREECAD_BIND_PATH:/home/user"
    command: ["su user -c \\\"freecad\\\""]
```
