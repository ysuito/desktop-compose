# keepassxc image

Edit following volume bind path.
- KEEPASSXC_BIND_PATH

## App specific configuration
```yaml
  keepassxc:
    build: https://github.com/ysuito/desktop-compose.git#master:src/keepassxc
    image: keepassxc
    container_name: keepassxc
    depends_on:
      - ubuntubase
    volumes:
      - "KEEPASSXC_BIND_PATH:/home/user"
    command: ["su user -c \\\"keepassxc\\\""]
```