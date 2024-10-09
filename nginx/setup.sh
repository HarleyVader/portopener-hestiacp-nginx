#!/bin/bash

# Colors for output
coloroff='\033[0m'
magenta='\033[0;35m'
red='\033[0;31m' 
green='\033[0;32m' 
blue='\033[0;34m'
cyan='\033[0;36m'
white='\033[0;37m'
yellow='\033[0;33m' 

# Display banner
sleep 1
echo -e $magenta " _____ ______   _______   ___       ___  __    ________  ________   _______   ________     " $coloroff
echo -e $magenta "|\   _ \  _   \|\  ___ \ |\  \     |\  \|\  \ |\   __  \|\   ___  \|\  ___ \ |\   __  \    " $coloroff
echo -e $magenta "\ \ \ \ \_\ \  \ \   __/|\ \  \    \ \  \/  /|\ \  \|\  \ \ \ \ \  \ \   __/|\ \  \|\  \   " $coloroff
echo -e $magenta " \ \ \ \|__| \  \ \  \_|/_\ \  \    \ \   ___  \ \   __  \ \ \ \ \  \ \  \_|/_\ \   __  \  " $coloroff
echo -e $magenta "  \ \  \    \ \  \ \  \_|\ \ \  \____\ \ \ \ \  \ \  \ \  \ \ \ \ \  \ \  \_|\ \ \  \ \  \ " $coloroff
echo -e $magenta "   \ \__\    \ \__\ \_______\ \_______\ \_\ \ \__\ \__\ \__\ \_\ \ \__\ \_______\ \__\ \__\ " $coloroff
echo -e $magenta "    \|__|     \|__|\|_______|\|_______|\|__| \|__|\|__|\|__| \|__|\|_______|\|__|\|__|" $coloroff
echo -e $cyan "melkanea" $magenta "bash" $white "hestiacp" $magenta "nginx" $cyan "portopener" $coloroff

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <user> <port> <location>"
    exit 1
fi

# Assign arguments to variables
user=$1
port=$2
location=$3
ip=$(hostname -I | awk '{print $1}')
if [ $? -ne 0 ]; then
    echo -e "${red}Failed to get IP address${coloroff}"
    exit 1
fi

# Define paths
home=/home
domain=bambisleep.chat
nodeapp=js-lmstudio-sdk
docroot=$home/$user/web/$domain/$nodeapp

# Display configuration
echo -e $magenta "user: "$user $coloroff
echo -e $red "domain: "$domain $coloroff
echo -e $green "ip: "$ip $coloroff
echo -e $blue "home: "$home $coloroff
echo -e $cyan "nodeapp: "$nodeapp $coloroff
echo -e $yellow "docroot: "$docroot $coloroff
sleep 2

# Create necessary directories
if [ ! -d "$docroot" ]; then
  mkdir -p "$docroot"
fi
chown -R $user:$user "$docroot"
echo -e "${green}Changed ownership of $docroot to $user${coloroff}"
sleep 1

# Ensure the script is run with sudo -i
if [ "$EUID" -ne 0 ]; then
    echo -e "${red}Please run this script as root using 'sudo -i'${coloroff}"
    exit 1
fi
echo -e "${green}Script is running as root${coloroff}"
sleep 1

# Install Node.js
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
echo -e "${green}NVM installation script downloaded and executed${coloroff}"
sleep 1

# Load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
echo -e "${green}NVM loaded${coloroff}"
sleep 1

if nvm -v > /dev/null 2>&1; then
    echo -e "${green}NVM is installed${coloroff}"
else
    echo -e "${red}NVM is not installed. Exiting...${coloroff}"
    exit 1
fi
sleep 1

nvm install node
echo -e "${green}Node.js installed${coloroff}"
sleep 1

# Create the .sock file using a Node.js script
node -e "
const fs = require('fs');
const path = '$docroot/app.sock';
fs.closeSync(fs.openSync(path, 'w'));
console.log('Socket file created at ' + path);
"
echo -e "${green}Socket file created at $docroot/app.sock${coloroff}"
sleep 1

npm install pm2 -g
echo -e "${green}PM2 installed globally${coloroff}"
sleep 1

# Start the application using pm2
pm2 start $docroot/server.js
echo -e "${green}Application started using PM2${coloroff}"
sleep 1

# Link pm2 to the cloud dashboard automatically

echo -e "${green}PM2 linked to the cloud dashboard${coloroff}"
sleep 1

# Link pm2 to the cloud dashboard automatically
sleep 5

# Check if file exists before removing it
if [ -f "$docroot/app.sock" ]; then
  rm "$docroot/app.sock"
fi

cp ./create_sock.py "$docroot/create_sock.py"
chmod +x "$docroot/create_sock.py"

# Check if file exists before changing permissions
if [ -f "$docroot/app.sock" ]; then
  chmod 777 "$docroot/app.sock"
fi

# Predefined locations
source_file="./nginx.conf_melkanea"
# Check if the template file exists
if [ ! -f "$source_file" ]; then
    echo "Error: Template file '$source_file' not found."
    exit 1
fi

# Define the file paths for placeholder replace
FILE_PATH="$home/$user/conf/web/$domain/nginx.conf_$port"
FILE_PATH_SSL="$home/$user/conf/web/$domain/nginx.ssl.conf_$port"
cp "$source_file" "$home/$user/conf/web/$domain/nginx.conf_$port"
cp "$source_file" "$home/$user/conf/web/$domain/nginx.ssl.conf_$port"

# Replace placeholders
sed -i "s/%port%/$port/g" "$FILE_PATH"
sed -i "s/%ip%/$ip/g" "$FILE_PATH"
sed -i "s/%location%/$location/g" "$FILE_PATH"
sed -i "s/%port%/$port/g" "$FILE_PATH_SSL"
sed -i "s/%ip%/$ip/g" "$FILE_PATH_SSL"
sed -i "s/%location%/$location/g" "$FILE_PATH_SSL"

echo "Files '$FILE_PATH' and '$FILE_PATH_SSL' have been created based on the template and placeholders have been replaced."