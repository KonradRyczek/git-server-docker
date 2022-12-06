FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y git-all openssh-server sudo

COPY sshd_config /etc/ssh/sshd_config

# git user
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test \
    && echo 'test:test' | chpasswd
# ssh user
RUN adduser git \
    && echo 'git:password' | chpasswd



WORKDIR /home/git
RUN mkdir .ssh && chmod 700 .ssh 
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
# adding ssh key
COPY id_rsa.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /home/git/.ssh/authorized_keys
RUN rm /tmp/id_rsa.pub

# creating bare repo for testing
RUN git init --bare test.git
RUN chown -R git /home/git

RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
