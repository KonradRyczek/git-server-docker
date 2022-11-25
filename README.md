## Project: git-server on a Docker container
Docker container running git as a server.  
Permission to repositories will be set up using [gitosis](https://github.com/tv42/gitosis).

### Useful commands:
Rebuilding image after changes:
`docker build . -t kr/git-server`
Executing container with open shell:
`docker run -it kr/git-server bash`

