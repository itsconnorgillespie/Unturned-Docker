FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV GAME_INSTALL_DIR=/home/steam/Unturned
ENV GAME_ID=1110390
ENV SERVER_NAME=server
ENV STEAMCMD_DIR=/home/steam/steamcmd

EXPOSE 27015/udp
EXPOSE 27016/udp

RUN apt-get update && \
    apt-get install -y \
        curl \
        lib32gcc-s1 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --system --home /home/steam steam

USER steam
WORKDIR $STEAMCMD_DIR

RUN mkdir -p "$GAME_INSTALL_DIR" && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz && \
    ./steamcmd.sh +quit && \
    mkdir -p /home/steam/.steam/sdk64/ && \
    cp -f linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

COPY --chown=steam:steam --chmod=755 init.sh .

ENTRYPOINT ["./init.sh"]