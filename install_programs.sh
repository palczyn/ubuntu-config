!#/bin/bash

#install google chrome
wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install google-chrome-stable -y
echo "Google Chrome has been successfully installed."

#install spotify alacritty postman
snap install alacritty --classic
snap install spotify
snap install postman

#install neovim i3 feh polybar
apt install neovim i3-wm i3lock feh polybar maim xclip xdotool -y

# Exit the script
exit 0
