FROM debian:buster-slim
MAINTAINER Ferdinando Santacroce

RUN apt-get update -qq \
    && apt-get install -y -qq openssh-client git lftp ssh sshpass \
    && rm -rf /var/lib/apt/lists/*
