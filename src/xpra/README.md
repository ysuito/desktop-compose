# Xpra image

Edit following environment variable.
- REMOTE_HOST_IN_SSH_CONFIG
- REMOTE_DESKTOP_COMPOSE_FILE

If you use rootless docker in the remote host, edit the following.
- REMOTE_DOCKER_HOST

In case of WSLg, uncomment `network_mode: host`.

## Local configuration
Add to `local-compose.yaml`.
```yml:local-compose.yaml
  client:
    build: https://github.com/ysuito/desktop-compose.git#master:src/xpra
    image: xpra
    container_name: xpra-client
    depends_on:
      - ubuntubase
    # network_mode: host
    working_dir: /home/user
    environment:
      - REMOTE_HOST=REMOTE_HOST_IN_SSH_CONFIG             # HOSTNAME IN SSH CONFIG
      - REMOTE_COMPOSE_PATH=REMOTE_DESKTOP_COMPOSE_FILE   # REMOTE COMPOSE FILE PATH
      - REMOTE_DOCKER_HOST=unix:///var/run/docker.sock    # REMOTE DOCKER SOCKET
      - XPRA_PORT=10001                                   # XPRA LISTEN PORT
      - XPRA_DISPLAY=101                                  # XPRA DISPLAY NUMBER
      - UID=1000                                          # USER ID IN CONTAINER
      - GID=1000                                          # GROUP ID IN CONTAINER
      - DISPLAY=:101                                      # XSERVER DISPLAY NUMBER
      - XAUTHORITY=/home/user/.Xauthority                 # XSERVER AUTH FILE PATH
      - PULSE_COOKIE=/home/user/.config/pulse/cookie      # PULSE AUTH FILE PATH
      - PULSE_SERVER=unix:/tmp/pulse/native               # PULSE SERVER SOCKET PATH
    volumes:
      # SSH DIR
      - type: bind
        source: ${HOME}/.ssh/
        target: /ssh
        read_only: true
      # XSERVER SOCKET
      - type: bind
        source: /tmp/.X11-unix/X0
        target: /tmp/.X11-unix/X101
      # XSERVER AUTH FILE
      - type: bind
        source: $XAUTHORITY
        target: /auth/.Xauthority
        read_only: true
      # PULSE AUDIO SOCKET
      - type: bind
        source: ${XDG_RUNTIME_DIR}/pulse/native
        target: /tmp/pulse/native
      # PULSE AUDIO AUTH FILE
      - type: bind
        source: ${HOME}/.config/pulse/cookie
        target: /auth/.config/pulse/cookie
        read_only: true
    devices:
      - /dev/dri:/dev/dri                                            # SHARE GPU
    command: [
      "bash",
      "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.ssh; \
      cp -R /ssh/* /home/user/.ssh; \
      chown user:user -R /home/user/.ssh; \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      su user -c \" \
        ssh -L $${XPRA_PORT}:127.0.0.1:$${XPRA_PORT} \
        -o \\\"PermitLocalCommand=yes\\\" \
        -o \\\"LocalCommand=(sleep 3 && \
                xpra attach tcp://127.0.0.1:$${XPRA_PORT}/$${XPRA_DISPLAY} \
                --webcam=no --printing=no ) &\\\" \
        -o \\\"RequestTTY=force\\\" \
        $${REMOTE_HOST} \
        bash -c \
        \\\"\
          uname -a;
          bash --init-file <(\
            echo export PATH=~/bin:$PATH;\
            echo export DOCKER_HOST=$${REMOTE_DOCKER_HOST};\
            echo alias dc=\\'docker compose -f $${REMOTE_COMPOSE_PATH}\\';\
            echo dc up server\\&\
          )\\\"\
      \"
      "]
```

## Remote configuration
Add to `remote-compose.yaml`.
```yml:remote-compose.yaml
  server:
    build: https://github.com/ysuito/desktop-compose.git#master:src/xpra
    image: xpra
    container_name: xpra-server
    depends_on:
      - ubuntubase
    working_dir: /home/user
    environment:
      - UID=1000                                          # USER ID IN CONTAINER
      - GID=1000                                         # GROUP ID IN CONTAINER
    ports:
      - 127.0.0.1:10001:10001
    volumes:
      # XSERVER SOCKET
      - type: volume
        source: x11
        target: /tmp/.X11-unix/
      # SERVER HOME FOR SHAREING COOKIES
      - type: volume
        source: auth
        target: /home/user
      # PULSE AUDIO SOCKET
      - type: volume
        source: pulse
        target: /tmp/xpra/101/pulse/pulse/
    devices:
      - /dev/dri:/dev/dri                                            # SHARE GPU
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      chmod 1777 /tmp/.X11-unix; \
      chown -R user:user /home/user /tmp/xpra/101; \
      su user -c \" \
        xpra start :101 --bind-tcp=0.0.0.0:10001 \
          --video-encoders=jpeg --no-daemon --webcam=no \
          --printing=no --start=\\\"xhost +local:\\\"\" \
      "]
```
