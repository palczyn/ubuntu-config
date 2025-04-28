#!/bin/bash

set -e # Exit immiediately when a non-zero status occurs
set -u # Treat unset variables as an error

is_installed() {
	dpkg-query -W "$1" &> /dev/null
}

is_snap_installed() {
	snap list "$1" &> /dev/null
}

# Install Google Chrome
if ! command -v google-chrome &> /dev/null; then
	echo "Installing Google Chrome..."
	
	sudo mkdir -p /etc/apt/keyrings
	if [ ! -f /etc/apt/keyrings/google-chrome.gpg ]; then
		wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/google-chrome.gpg > /dev/null
	else
		echo "Google Chrome GPG key already exists."
	fi

	if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
		echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
	else
		echo 'Google Chrome repository already exists.'
	fi
	
	sudo apt-get update
	sudo apt-get install google-chrome-stable -y
	echo "Google Chrome has been successfully installed."
else
	echo "Google Chrome is already installed"
fi

# Install snap packages
snap_classic_packages = ( alacritty )
for snap_pkg in snap_classic_packages; do
	if ! is_snap_installed "$snap_pkg"; then
		echo "Installing $snap_pkg via snap..."
		sudo snap install "$snap_pkg" --classic
	else
		echo "$snap_pkg is already installed via snap."
	fi
done

snap_packages = ( spotify postman )
for snap_pkg in snap_packages; do
	if ! is_snap_installed "$snap_pkg"; then
		echo "Installing $snap_pkg via snap..."
		sudo snap install "$snap_pkg" --classic
	else
		echo "$snap_pkg is already installed via snap."
	fi
done

# Install apt packages
packages=( neovim i3-wm i3lock feh polybar maim xclip xdotool -y )
packages_to_install=()

for pkg in "${packages[@]}"; do
	if ! is_installed "$pkg"; then
		packages_to_install+=("$pkg")
	fi
done

if [ ${#packages_to_install[@]} -ne 0 ]; then
	echo "Installing missing apt packages: ${packages_to_install[*]}"
	sudo apt-get update
	sudo apt-get install -y "${packages_to_install[@]}"
else
	echo "All required apt packages are already installed."
fi

# Move configs do config directory
config_dirs=( ./nvim ./polybar ./i3 )
for dir in "${config_dirs[@]}"; do
	if [ -d "$dir" ]; then
		echo "Moving $dir to ~/.config/$nvim_config_dir"
		mv -f "$dir" "~/.config"
	else
		echo "Cannot find directory $dir"
	fi
done

# Exit the script
exit 0
