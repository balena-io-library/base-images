#!/bin/bash

# Restarting the application re-fetches the current
# commit, therefore discards changes we make to /app
# directly.
# This workaround saves the changes to /data/.resin-watch
# and merges those changes to /app in each restart
mkdir -p /data/.resin-watch

# Only attempt to copy if the directory is not empty
if [ "$(ls -A /data/.resin-watch)" ]; then
  cp -rf /data/.resin-watch/* /usr/src/app/
fi

GREEN='\033[0;32m'
echo -e "${GREEN}Sync mode enabled."
