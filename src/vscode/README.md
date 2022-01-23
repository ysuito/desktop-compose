# vscode image

Edit following environment variable.
- VSCODE_BIND_PATH

Edit following volume bind path.
- VSCODE_BIND_PATH
- DOCKER_SOCK_PATH

## Dependency
[chrome image configuration](../chrome/README.md) needed.

## Remote Container
If you develop with remote containers, add the following conf to `devcontainer.json`
```json:devcontainer.json
  "workspaceMount": "source=${localEnv:BIND_PATH}/${localWorkspaceFolderBasename},target=/workspace,type=bind,consistency=cached",
  "workspaceFolder": "/workspace"
```

## App specific configuration
```yaml
  vscode:
    build: https://github.com/ysuito/desktop-compose.git#master:src/vscode
    image: vscode
    container_name: vscode
    depends_on:
      - chrome
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
      - BIND_PATH=VSCODE_BIND_PATH
      - DONT_PROMPT_WSL_INSTALL=1
    volumes:
      - "VSCODE_BIND_PATH:/home/user"
    cap_add:
      - SYS_CHROOT
      - SYS_ADMIN
    command: ["usermod -aG root,docker user; su user -c \\\"code --verbose --enable-features=UseOzonePlatform --ozone-platform=wayland\\\""]
```
