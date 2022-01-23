FROM ubuntubase

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb [arch=$(dpkg --print-architecture)] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
   && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
   && apt update && apt install -y \
   xvfb x11-xserver-utils x264 ffmpeg xpra \
   python3-pip \
   && pip3 install pyinotify \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*
