FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y git python2 python-setuptools sudo openssh-server

COPY sshd_config /etc/ssh/sshd_config

RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo -u 1000 test \
    && echo 'test:test' | chpasswd

WORKDIR /home/test
RUN mkdir .ssh && chmod 700 .ssh 
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
# adding ssh key
COPY id_rsa.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /home/test/.ssh/authorized_keys


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
RUN gitosis-init < /tmp/id_rsa.pub
USER root
RUN rm /tmp/irycz@IGLU.pub

WORKDIR /srv/simple-git.com
RUN chown -R git /srv
RUN chmod 700 .ssh 
RUN chmod 600 .ssh/authorized_keys

RUN chown -R test /home/test
RUN service ssh start

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]