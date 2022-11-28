FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y git-all openssh-server sudo

# COPY sshd_config /etc/ssh/sshd_config

# user git
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test \
    && echo 'test:test' | chpasswd
RUN adduser git \
    && echo 'git:password' | chpasswd

RUN service ssh start

# adding ssh key to home/git/.ssh/authorized_keys
# WORKDIR /home/git
# RUN mkdir .ssh && chmod 700 .ssh
# RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
# COPY git-server-docker.pub /tmp/git-server-docker.pub
# RUN cat /tmp/git-server-docker.pub >> /home/git/.ssh/authorized_keys
# RUN rm /tmp/git-server-docker.pub

# # creating bare repo for testing
# RUN mkdir project.git
# RUN cd project.git \ 
#     && git init --bare

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
