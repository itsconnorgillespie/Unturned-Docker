#!/bin/bash
set -e

cd "$STEAMCMD_INSTALL_DIR" || exit

bash ./steamcmd.sh \
    +force_install_dir "$GAME_INSTALL_DIR" \
    +login anonymous \
    +app_update "$GAME_ID" validate \
    +quit

cd "$GAME_INSTALL_DIR" || exit

ulimit -n 2048
export TERM=xterm

if [ -d "./Unturned_Headless_Data" ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(dirname $0)/Unturned_Headless_Data/Plugins/x86_64/
else
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(dirname $0)/Unturned_Headless/Plugins/x86_64/
fi

if [ "${OPENMOD_INSTALL:-false}" = "true" ]; then
    if [ ! -d "$GAME_INSTALL_DIR/Modules/OpenMod.Unturned.Module" ]; then
        mkdir -p "$GAME_INSTALL_DIR/Modules"
        curl -fsSL "$OPENMOD_INSTALL_URL" -o OpenMod.Unturned.Module.zip
        unzip OpenMod.Unturned.Module.zip -d "$GAME_INSTALL_DIR/Modules"
        rm OpenMod.Unturned.Module.zip
    fi
fi

if [ "${ROCKETMOD_INSTALL:-false}" = "true" ]; then
    if [ ! -d "$MODULES_DIR/Rocket.Unturned" ]; then
      cp -rf "$GAME_INSTALL_DIR"/Extras/Rocket.Unturned/ "$GAME_INSTALL_DIR"/Modules/
    fi
fi

exec ./Unturned_Headless.x86_64 \
    -batchmode \
    -nographics \
    +secureserver/"$SERVER_NAME"
