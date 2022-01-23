# flutter image

Edit following volume bind path.
- FLUTTER_BIND_PATH

## Dependency
- [chrome image configuration](../chrome/README.md) needed.
- [vscode image configuration](../vscode/README.md) needed.

## App specific configuration
```yaml
  flutter:
    build: https://github.com/ysuito/desktop-compose.git#master:src/flutter
    image: flutter
    container_name: flutter
    depends_on:
      - vscode
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
      - DONT_PROMPT_WSL_INSTALL=1
    volumes:
      - "FLUTTER_BIND_PATH:/home/user"
    cap_add:
      - SYS_CHROOT
      - SYS_ADMIN
    command: ["su user -c \\\"code --verbose --enable-features=UseOzonePlatform --ozone-platform=wayland\\\""]
```
