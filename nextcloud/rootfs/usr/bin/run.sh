#!/bin/bash
set -e

alias occ="php /share/nextcloud/html/occ"

SHARE_DIR=/share/nextcloud
if [ ! -d "${SHARE_DIR}" ]; then
    mkdir -p "${SHARE_DIR}"/html/data
    chown -R www-data:root "${SHARE_DIR}"
    chmod -R g=u "${SHARE_DIR}"
fi

CONFIG_PATH=/data/options.json
echo 'Starting with the following configuration:';
jq --raw-output 'keys[] as $k | select(.[$k] != "" and .[$k] != null) | "\t" + ($k | ascii_upcase) + "=\"" + (.[$k]|tostring) + "\"\n"' $CONFIG_PATH;
eval $(jq --raw-output 'keys[] as $k | select(.[$k] != "" and .[$k] != null) | "export " + ($k | ascii_upcase) + "=\"" + (.[$k]|tostring) + "\""' $CONFIG_PATH);

mount -t cifs -o ${SMB_OPTS} -v ${SMB_SHARE} ${SHARE_DIR}/html/data

/entrypoint.sh "$@"
