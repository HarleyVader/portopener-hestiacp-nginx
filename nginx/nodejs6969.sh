#!/bin/bash
user=brandynette
domain=bambisleep.chat
nodeapp=js-lmstudio-sdk
home=/home
docroot=$5

# Check if directory exists before creating it
if [ ! -d "$home/$user/web/$domain/$nodeapp" ]; then
  mkdir -p "$home/$user/web/$domain/$nodeapp"
fi

chown -R $user:$user "$home/$user/web/$domain/$nodeapp"

# Check if file exists before removing it
if [ -f "$home/$user/web/$domain/$nodeapp/app.sock" ]; then
  rm "$home/$user/web/$domain/$nodeapp/app.sock"
fi

# Use su as an alternative to runuser if runuser is not available
if command -v runuser &> /dev/null; then
  runuser -l $user -c "pm2 start $home/$user/web/$domain/$nodeapp/server.js"
else
  su - $user -c "pm2 start $home/$user/web/$domain/$nodeapp/server.js"
fi

sleep 5

# Check if file exists before changing permissions
if [ -f "$home/$user/web/$domain/$nodeapp/app.sock" ]; then
  chmod 777 "$home/$user/web/$domain/$nodeapp/app.sock"
fi