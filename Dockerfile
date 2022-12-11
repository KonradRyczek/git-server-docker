FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y git python2 python-setuptools sudo

# git user
RUN adduser \
    --system \
    --shell /bin/sh \
    --gecos 'git version control' \
    --group \
    --disabled-password \
    --home /srv/simple-git.com \
    git

WORKDIR /tmp
RUN git clone https://github.com/tv42/gitosis.git
RUN cd gitosis \
    && python2 setup.py install
COPY irycz@IGLU.pub /tmp/irycz@IGLU.pub

USER git
RUN gitosis-init < irycz@IGLU.pub
USER root
RUN rm /tmp/irycz@IGLU.pub

WORKDIR /
RUN chown -R git:git /srv

EXPOSE 22