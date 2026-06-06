## Unturned Docker Image
This repository aims to reduce the hassle for setting up an Unturned Dedicated Server by leveraging Docker. By utilizing the environment variables below, this image can also automate the installation of RocketMod and OpenMod. The Docker image is currently hosted at `ghcr.io/itsconnorgillespie/unturned-docker`.

### Quickstart Commands
The following command creates an Unturned server with OpenMod and RocketMod installed. Server data will be stored in a local `data/` directory relative to where the command is executed.

```sh
docker run -it -d \
  -v ./data:/home/steam/Unturned \
  -p 27015:27015 \
  -p 27016:27016 \
  -e SERVER_NAME=server \
  -e OPENMOD_INSTALL=true \
  -e ROCKETMOD_INSTALL=true \
  --restart unless-stopped \
  --name unturned \
  ghcr.io/itsconnorgillespie/unturned-docker:latest
```

### Environment Variables
The following environment variables can be utilized to tailor the Docker image to your specific needs.

1. `GAME_INSTALL_DIR`
- Expected: string
- Default: "/home/steam/Unturned"
- Description: Define an alternate game installation directory.

2. `SERVER_NAME`
- Expected: string
- Default: "server"
- Description: Define the name of the server.

3. `OPENMOD_INSTALL_URL`
- Expected: string
- Default: *Latest OpenMod GitHub Release*
- Description: Define a specific OpenMod module to install. 

4. `OPENMOD_INSTALL`
- Expected: "true" or "false"
- Default: "false"
- Description: Install OpenMod if not already installed.

5. `ROCKETMOD_INSTALL`
- Expected: "true" or "false"
- Default: "false"
- Description: Install RocketMod if not already installed.
