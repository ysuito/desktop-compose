# fritzing image

Edit following volume bind path.
- FRITZING_BIND_PATH

## Local configuration
```yml:local-compose.yml
  fritzing:
    build: https://github.com/ysuito/desktop-compose.git#master:src/fritzing
    image: fritzing
    container_name: fritzing
    depends_on:
      - ubuntubase
    working_dir: /home/user
    environment:
      - UID=1000
      - GID=1000
      - DISPLAY=:101
      - XAUTHORITY=/home/user/.Xauthority
      - PULSE_COOKIE=/home/user/.config/pulse/cookie
      - PULSE_SERVER=unix:/tmp/pulse/native
    volumes:
      - "FRITZING_BIND_PATH:/home/user"
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
    cap_drop:
      - ALL
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      su user -c \"fritzing\"\
      "]
```

## Remote configuration
```yml:remote-compose.yml
  fritzing:
    build: https://github.com/ysuito/desktop-compose.git#master:src/fritzing
    image: fritzing
    container_name: fritzing
    depends_on:
      - ubuntubase
    working_dir: /home/user
    environment:
      - UID=1000
      - GID=1000
      - DISPLAY=:101
      - XAUTHORITY=/home/user/.Xauthority
      - PULSE_COOKIE=/home/user/.config/pulse/cookie
      - PULSE_SERVER=unix:/tmp/pulse/native
    volumes:
      - "FRITZING_BIND_PATH:/home/user"
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
    cap_drop:
      - ALL
    command: [
      "bash", "-c",
      "groupadd -g $${GID} user && \
      useradd -s /bin/bash -u $${UID} -g user user && \
      mkdir -p /home/user/.config/pulse/; \
      cp /auth/.Xauthority /home/user/.Xauthority; \
      cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie; \
      chown -R user:user /home/user; \
      su user -c \"fritzing\"\
      "]
```