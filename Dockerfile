FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMD_INSTALL_DIR=/home/steam/steamcmd
ENV GAME_INSTALL_DIR=/home/steam/Unturned
ENV GAME_ID=1110390
ENV SERVER_NAME=server
ENV OPENMOD_INSTALL_URL=https://github.com/openmod/openmod/releases/latest/download/OpenMod.Unturned.Module.zip
ENV OPENMOD_INSTALL=false
ENV ROCKETMOD_INSTALL=false

EXPOSE 27015/udp
EXPOSE 27016/udp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        lib32gcc-s1 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser \
    --home /home/steam \
    --disabled-password \
    --shell /bin/bash \
    --uid 1000 \
    --quiet \
    steam && \
    mkdir -p $STEAMCMD_INSTALL_DIR $GAME_INSTALL_DIR && \
    chown -R steam:steam /home/steam

USER steam
WORKDIR $STEAMCMD_INSTALL_DIR

RUN curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz && \
    ./steamcmd.sh +quit && \
    mkdir -p /home/steam/.steam/sdk64/ && \
    cp -f linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

COPY --chown=steam:steam --chmod=755 init.sh .

ENTRYPOINT ["./init.sh"]