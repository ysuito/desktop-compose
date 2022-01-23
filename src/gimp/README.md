# gimp image

Edit following volume bind path.
- GIMP_BIND_PATH

## App specific configuration
```yaml
  gimp:
    build: https://github.com/ysuito/desktop-compose.git#master:src/gimp
    image: gimp
    container_name: gimp
    depends_on:
      - ubuntubase
    volumes:
      - "GIMP_BIND_PATH:/home/user"
    command: ["su user -c \\\"gimp\\\""]
```
