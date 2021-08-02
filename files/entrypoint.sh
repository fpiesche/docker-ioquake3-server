#!/bin/sh
echo "Launching ioquake3 server version ${IOQUAKE3_COMMIT}..."

echo "Copying default configs..."
    cp /usr/local/games/quake3/default-configs/* /usr/local/games/quake3/baseq3/

if [ "$(ls -A /usr/local/games/quake3/configs)" ]; then
    echo "Copying custom configs..."
    cp /usr/local/games/quake3/configs/* /usr/local/games/quake3/baseq3/
fi

if [ -z "${SERVER_ARGS}" ]; then
    echo "No additional server arguments found; running default Deathmatch configuration."
    SERVER_ARGS="+exec server_ffa.cfg"
fi

if [ -z "${SERVER_MOTD}" ]; then
    SERVER_MOTD="Welcome to my Quake 3 server!"
fi

if [ -z "${ADMIN_PASSWORD}" ]; then
    ADMIN_PASSWORD=$(cat /dev/urandom | head -c${1:-32} | base64)
    echo "No admin password set; defaulting to ${ADMIN_PASSWORD}."
fi

IOQ3DED_BIN=$(ls /usr/local/games/quake3/ioq3ded*)
if [ $(echo ${IOQ3DED_BIN} | wc -l) -gt 1 ]; then
    echo "Found more than one file matching /usr/local/games/quake3/ioq3ded*:"
    echo ${IOQ3DED_BIN}
    echo "Cannot determine name of ioquake3 server executable."
    echo "Please report this as an issue at https://git.yellowkeycard.net/outrider/ioquake3-docker"
    echo "including your Docker command line (or compose file/Kubernetes manifest) and the above"
    echo "list of executables found."
    exit 1
fi

echo "Command line:"
echo '${IOQ3DED_BIN} +seta rconPassword "${ADMIN_PASSWORD}" +g_motd "${SERVER_MOTD}" +exec common.cfg ${SERVER_ARGS}"'

${IOQ3DED_BIN} \
    +seta rconPassword "${ADMIN_PASSWORD}" \
    +g_motd "${SERVER_MOTD}" \
    +exec common.cfg \
    ${SERVER_ARGS}
