FROM ubuntubase:latest

ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:phoerious/keepassxc && \
    apt-get update && apt-get install -y keepassxc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*