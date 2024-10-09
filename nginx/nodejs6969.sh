#!/bin/bash
user=brandynette
domain=bambisleep.chat
nodeapp=js-lmstudio-sdk
home=/home
docroot=$5

mkdir "$home/$user/web/$domain/$nodeapp"
chown -R $user:$user "$home/$user/web/$domain/$nodeapp"
rm "$home/$user/web/$domain/$nodeapp/app.sock"
runuser -l $user -c "pm2 start $home/$user/web/$domain/$nodeapp/server.js"
sleep 5
chmod 777 "$home/$user/web/$domain/$nodeapp/app.sock"