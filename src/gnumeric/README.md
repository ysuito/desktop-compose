# gnumeric image

Edit following volume bind path.
- GNUMERIC_BIND_PATH

## App specific configuration
```yaml
  gnumeric:
    build: https://github.com/ysuito/desktop-compose.git#master:src/gnumeric
    image: gnumeric
    container_name: gnumeric
    depends_on:
      - ubuntubase
    volumes:
      - "GNUMERIC_BIND_PATH:/home/user"
    command: ["su user -c \\\"gnumeric\\\""]
```
