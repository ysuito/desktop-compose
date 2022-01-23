FROM ubuntubase:latest

ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:mati75/gimp30 \
    && apt-get update && apt-get install -y \
        gimp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
