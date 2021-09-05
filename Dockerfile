FROM jenkins4eval/jenkins:latest
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install gcc mono-mcs sshpass && \
    rm -rf /var/lib/apt/lists/*
