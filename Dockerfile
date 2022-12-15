FROM ubuntu:latest

# ARG to avoid prompts when installing dependencies
ARG DEBIAN_FRONTEND=noninteractive
# Replace below file names with your own keys:
ARG GIT_PUBLIC_KEY="gitosis-key.pub"
ARG SSH_PUBLIC_KEY="gitosis-key.pub"



RUN apt-get update 
RUN apt-get install -y git python2 python-setuptools sudo openssh-server


COPY sshd_config /etc/ssh/sshd_config
# COPY $SSH_PUBLIC_KEY /tmp/$SSH_PUBLIC_KEY
COPY $GIT_PUBLIC_KEY /tmp/$GIT_PUBLIC_KEY


# ssh user:
RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo -u 1000 test \
    && echo 'test:test' | chpasswd

# gitosis user:
RUN adduser \
    --system \
    --shell /bin/sh \
    --gecos 'git version control' \
    --group \
    --disabled-password \
    --home /srv/simple-git.com \
    git


# ssh user setup:
WORKDIR /home/test
RUN mkdir .ssh && chmod 700 .ssh 
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
RUN cat /tmp/$SSH_PUBLIC_KEY >> /home/test/.ssh/authorized_keys
RUN chown -R test /home/test


# gitosis setup
WORKDIR /tmp
RUN git clone https://github.com/tv42/gitosis.git
RUN cd gitosis \
    && python2 setup.py install
USER git
RUN gitosis-init < /tmp/$GIT_PUBLIC_KEY
USER root
WORKDIR /srv/simple-git.com
RUN chown -R git /srv
RUN chmod 700 .ssh 
RUN chmod 600 .ssh/authorized_keys

# RUN rm /tmp/$SSH_PUBLIC_KEY
RUN rm /tmp/$GIT_PUBLIC_KEY

RUN service ssh start

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]