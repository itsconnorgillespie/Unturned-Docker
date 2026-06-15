#!/bin/bash
set -e

cd "$STEAMCMD_INSTALL_DIR" || exit

bash ./steamcmd.sh \
    +force_install_dir "$GAME_INSTALL_DIR" \
    +login anonymous \
    +app_update "$GAME_ID" validate \
    +quit

mkdir -p /home/steam/.steam/sdk64
cp -f "$STEAMCMD_INSTALL_DIR/linux64/steamclient.so" /home/steam/.steam/sdk64/steamclient.so

cd "$GAME_INSTALL_DIR" || exit

ulimit -n 2048
export TERM=xterm

if [ -d "./Unturned_Headless_Data" ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(dirname $0)/Unturned_Headless_Data/Plugins/x86_64/
else
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(dirname $0)/Unturned_Headless/Plugins/x86_64/
fi

OPENMOD_ENABLED=${OPENMOD_INSTALL:-false}
ROCKETMOD_ENABLED=${ROCKETMOD_INSTALL:-false}
MODULES_DIR="$GAME_INSTALL_DIR/Modules"
OPENMOD_DIR="$MODULES_DIR/OpenMod.Unturned.Module"
ROCKETMOD_DIR="$MODULES_DIR/Rocket.Unturned"

if [ "$OPENMOD_ENABLED" = "true" ]; then
    if [ ! -d "$OPENMOD_DIR" ]; then
        mkdir -p "$MODULES_DIR"
        curl -fsSL "$OPENMOD_INSTALL_URL" -o OpenMod.Unturned.Module.zip
        unzip -o -q OpenMod.Unturned.Module.zip -d "$MODULES_DIR"
        rm OpenMod.Unturned.Module.zip
    fi
elif [ -d "$OPENMOD_DIR" ]; then
    rm -rf "$OPENMOD_DIR"
fi

if [ "$ROCKETMOD_ENABLED" = "true" ]; then
    if [ ! -d "$ROCKETMOD_DIR" ]; then
        cp -rf "$GAME_INSTALL_DIR/Extras/Rocket.Unturned/" "$MODULES_DIR/"
    fi
elif [ -d "$ROCKETMOD_DIR" ]; then
    rm -rf "$ROCKETMOD_DIR"
fi

exec ./Unturned_Headless.x86_64 \
    -batchmode \
    -nographics \
    +secureserver/"$SERVER_NAME"
