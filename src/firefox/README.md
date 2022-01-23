# firefox image

Edit following volume bind path.
- FIREFOX_BIND_PATH

## Local configuration
```yml:local-compose.yml
  firefox:
    build: https://github.com/ysuito/desktop-compose.git#master:src/firefox
    image: firefox
    container_name: firefox
    depends_on:
      - ubuntubase
    network_mode: host
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
      - UID=1000                                          # USER ID IN CONTAINER
      - GID=1000                                          # GROUP ID IN CONTAINER
      - DISPLAY=:101                                      # XSERVER DISPLAY NUMBER
      - XAUTHORITY=/home/user/.Xauthority                 # XSERVER AUTH FILE PATH
      - PULSE_COOKIE=/home/user/.config/pulse/cookie      # PULSE AUTH FILE PATH
      - PULSE_SERVER=unix:/tmp/pulse/native               # PULSE SERVER SOCKET PATH
    volumes:
      # BIND HOME TO HOST
      - "FIREFOX_BIND_PATH:/home/user"
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
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
    cap_drop:
      - ALL
    devices:
      - /dev/dri:/dev/dri                                            # SHARE GPU
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      su user -c \"firefox --new-instance\"\
      "]
```

## Remote configuration
```yml:remote-compose.yml
  firefox:
    build: https://github.com/ysuito/desktop-compose.git#master:src/firefox
    image: firefox
    container_name: firefox
    depends_on:
      - ubuntubase
    network_mode: host
    working_dir: /home/user
    shm_size: 2GB
    tmpfs: /dev/shm
    environment:
        UID=1000                                          # USER ID IN CONTAINER
      - GID=1000                                          # GROUP ID IN CONTAINER
      - DISPLAY=:101                                      # XSERVER DISPLAY NUMBER
      - XAUTHORITY=/home/user/.Xauthority                 # XSERVER AUTH FILE PATH
      - PULSE_COOKIE=/home/user/.config/pulse/cookie      # PULSE AUTH FILE PATH
      - PULSE_SERVER=unix:/tmp/pulse/native               # PULSE SERVER SOCKET PATH
    volumes:
      # BIND HOME TO HOST
      - "FIREFOX_BIND_PATH:/home/user"
      # XSERVER SOCKET
      - type: volume
        source: x11
        target: /tmp/.X11-unix/
      # SERVER HOME FOR SHAREING COOKIES
      - type: volume
        source: auth
        target: /auth/
        read_only: true
      # PULSE AUDIO SOCKET
      - type: volume
        source: pulse
        target: /tmp/pulse/
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
    cap_drop:
      - ALL
    devices:
      - /dev/dri:/dev/dri                                            # SHARE GPU
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      su user -c \"firefox --new-instance\"\
      "]
```
