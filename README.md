# Project: git-server on a Docker container

## Introduction
Docker container running git as a server.
Access to the container is also available through ssh.

## Setup
Create a ssh key on your machine, when created place the public key inside this directory. If the name of your key is id_rsa.pub the key will be copied when building the docker image. 
(See Dockerfile line 23-25)
## Usage:
### Creating repository
`cd /home/git`
`git init --bare reponame.git`

### Cloning repository
`git clone ssh://git@localhost:22/home/git/reponame.git`

### Docker - Useful commands:
Rebuilding image after changes: \
`docker build . -t kr/git-server` \
Executing container with open shell: \
`docker run -it --name git-server kr/git-server bash` 

## TODO:
Permission to repositories will be set up using [gitosis](https://github.com/tv42/gitosis).