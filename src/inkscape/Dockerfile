FROM ubuntubase:latest

ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:inkscape.dev/stable \
    && apt-get update && apt-get install -y \
    inkscape \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
