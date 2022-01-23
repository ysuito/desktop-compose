# chrome image

Edit following volume bind path.
- CHROME_BIND_PATH

## App specific configuration
```yaml
  chrome:
    build: https://github.com/ysuito/desktop-compose.git#master:src/chrome
    image: chrome
    container_name: chrome
    depends_on:
      - ubuntubase
    shm_size: 2GB
    tmpfs: /dev/shm
    volumes:
      - "CHROME_BIND_PATH:/home/user"
    cap_add:
      - SYS_CHROOT
      - SYS_ADMIN
    command: ["su user -c \\\"google-chrome --enable-features=UseOzonePlatform --ozone-platform=wayland\\\""]
```
