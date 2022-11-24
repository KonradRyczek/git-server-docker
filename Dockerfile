FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y git-all

RUN adduser git
RUN su git

WORKDIR /home/git
RUN mkdir .ssh && chmod 700 .ssh
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys

