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

## Local configuration
```yml:local-compose.yml
  vscode:
    build: https://github.com/ysuito/desktop-compose.git#master:src/vscode
    image: vscode
    container_name: vscode
    depends_on:
      - chrome
    network_mode: host
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
      - BIND_PATH=VSCODE_BIND_PATH
      - DONT_PROMPT_WSL_INSTALL=1
      - UID=1000
      - GID=1000
      - DISPLAY=:101
      - XAUTHORITY=/home/user/.Xauthority
      - PULSE_COOKIE=/home/user/.config/pulse/cookie
      - PULSE_SERVER=unix:/tmp/pulse/native
    volumes:
      - "VSCODE_BIND_PATH:/home/user"
      - type: bind
        source: DOCKER_SOCK_PATH
        target: /var/run/docker.sock
      - type: bind
        source: /tmp/.X11-unix/X0
        target: /tmp/.X11-unix/X101
      - type: bind
        source: $XAUTHORITY
        target: /auth/.Xauthority
        read_only: true
      - type: bind
        source: ${XDG_RUNTIME_DIR}/pulse/native
        target: /tmp/pulse/native
      - type: bind
        source: ${HOME}/.config/pulse/cookie
        target: /auth/.config/pulse/cookie
        read_only: true
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
      - SYS_CHROOT
      - SYS_ADMIN
    cap_drop:
      - ALL
    devices:
      - /dev/dri:/dev/dri
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      usermod -aG root,docker user; \
      su user -c \"code --verbose\"\
      "]
```

## Remote configuration
```yml:remote-compose.yml
  vscode:
    build: https://github.com/ysuito/desktop-compose.git#master:src/vscode
    image: vscode
    container_name: vscode
    depends_on:
      - chrome
    network_mode: host
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
      - BIND_PATH=VSCODE_BIND_PATH
      - DONT_PROMPT_WSL_INSTALL=1
      - UID=1000
      - GID=1000
      - DISPLAY=:101
      - XAUTHORITY=/home/user/.Xauthority
      - PULSE_COOKIE=/home/user/.config/pulse/cookie
      - PULSE_SERVER=unix:/tmp/pulse/native
    volumes:
      - "VSCODE_BIND_PATH:/home/user"
      - type: bind
        source: DOCKER_SOCK_PATH
        target: /var/run/docker.sock
      - type: volume
        source: x11
        target: /tmp/.X11-unix/
      - type: volume
        source: auth
        target: /auth/
        read_only: true
      - type: volume
        source: pulse
        target: /tmp/pulse/
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
      - SYS_CHROOT
      - SYS_ADMIN
    cap_drop:
      - ALL
    devices:
      - /dev/dri:/dev/dri
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      usermod -aG root,docker user; \
      su user -c \"code --verbose\"\
      "]
```
