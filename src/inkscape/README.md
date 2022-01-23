# inkscape image

Edit following volume bind path.
- INKSCAPE_BIND_PATH

## App specific configuration
```yaml
  inkscape:
    build: https://github.com/ysuito/desktop-compose.git#master:src/inkscape
    image: inkscape
    container_name: inkscape
    depends_on:
      - ubuntubase
    volumes:
      - "INKSCAPE_BIND_PATH:/home/user"
    command: ["su user -c \\\"inkscape\\\""]
```
