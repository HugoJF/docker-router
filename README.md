# docker-ogpagent

Dockerized version of the [Open Game Panel Linux Agent](https://github.com/OpenGamePanel/OGP-Agent-Linux).

Supports most of the essential features for running games, I don't use features like ftp or cron so there may be some holes in what actually works. Feel free to submit PR's!


This is easiest to use as part of `docker-compose`

```yaml
version: '2'
services:
  agent:
    image: joshhsoj1902/docker-ogpagent
    restart: always
    ports:
      - "12679:12679/tcp"
      - "27015:27015/tcp"
      - "27015:27015/udp"
    volumes:
      - ./ogp_agent/games:/home/ogp_agent/
    environment:
      - OGP_LOGFILE=/opt/OGP/ogp_agent.log
      - OGP_LISTEN_PORT=12679
      - OGP_LISTEN_IP=0.0.0.0
      - OGP_VERSION=v3372
      - OGP_KEY=encryption_key2
      - OGP_STEAM_LICENSE=Accept
      - OGP_SUDO_PASSWORD=ogpuser
      - OGP_SCREEN_LOG_LOCAL=1
      - OGP_DELETE_LOGS_AFTER=30
      - OGP_OGP_MANAGES_FTP=1
      - OGP_FTP_METHOD=PureFTPd
      - OGP_AUTORESTART_SERVER=1
```