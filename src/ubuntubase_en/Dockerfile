FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    pulseaudio \
    breeze \
    wget \
    gnupg \
    curl \
    gpg \
    apt-transport-https \
    ca-certificates lsb-release \
    git \
    zip \
    unzip \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
