#!/bin/bash

clear

echo -e "Legion Go Tools for Linux - script by Linux Gaming Central\n"

echo -e "Unlocking file system...\n"
sudo frzr-unlock
echo -e "Unlocked!\n"

while true; do
Choice=$(zenity --width 1000 --height 550 --list --radiolist --multiple --title "Legion Go Tools for Linux"\
	--column "Select One" \
	--column "Option" \
	--column="Description"\
	FALSE DECKY "Install Decky Loader"\
	FALSE UNINSTALL_DECKY "Uninstall Decky Loader"\
	FALSE TDP "Install or Update the Simple Decky TDP plugin"\
	FALSE UNINSTALL_TDP "Uninstall the Simple Decky TDP plugin"\
	FALSE RGB "Install or Update the RGB Decky plugin"\
	FALSE UNINSTALL_RGB "Uninstall the RGB Decky plugin"\
	FALSE ROGUE "Install or Update ROGueENEMY"\
	FALSE UNINSTALL_ROGUE "Uninstall ROGueENEMY"\
	FALSE HHD "Install or Update Handheld Daemon (HHD)"\
	FALSE UNINSTALL_HHD "Uninstall Handheld Daemon (HHD)"\
	FALSE STEAM_PATCH "Install Steam-Patch (warning: currently buggy!)"\
	FALSE UPDATE_STEAM_PATCH "Update Steam-Patch"\
	FALSE UNINSTALL_STEAM_PATCH "Uninstall Steam-Patch"\
	FALSE LEGOTHEME "Install the Legion Go theme for CSS Loader"\
	FALSE PS5toXBOX "Install the Xbox controller glyph theme for CSS Loader (recommended after installing HHD)"\
	TRUE EXIT "Exit this script")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]; then
	echo Goodbye!
	exit

elif [ "$Choice" == "DECKY" ]; then
	cd $HOME

	curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Decky Loader installation complete!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_DECKY" ]; then
	cd $HOME

	curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Decky Loader uninstallation complete!" --width 400 --height 75

elif [ "$Choice" == "TDP" ]; then
	curl -L https://raw.githubusercontent.com/aarron-lee/SimpleDeckyTDP/main/install.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Simple Decky TDP plugin installed/updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_TDP" ]; then
	if [ "$EUID" -eq 0 ]; then
		echo "Please do not run as root"
  		exit
	fi

	cd $HOME

	sudo rm -rf $HOME/homebrew/plugins/SimpleDeckyTDP
	
	sudo systemctl restart plugin_loader.service

	zenity --info --title "Legion Go Tools for Linux" --text "Simple Decky TDP removed!" --width 400 --height 75

elif [ "$Choice" == "RGB" ]; then
	curl -L https://raw.githubusercontent.com/aarron-lee/LegionGoRemapper/main/install.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go Remapper plugin installed/updated!" --width 400 --height 75
	
elif [ "$Choice" == "UNINSTALL_RGB" ]; then
	if [ "$EUID" -eq 0 ]
		then echo "Please do not run as root"
		exit
	fi
	
	cd $HOME

	sudo rm -rf $HOME/homebrew/plugins/LegionGoRemapper
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go Remapper plugin removed!" --width 400 --height 75

elif [ "$Choice" == "ROGUE" ]; then
	cd $HOME
	
	curl -sSL https://raw.githubusercontent.com/corando98/ROGueENEMY/main/chimera_install.sh | sudo sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "ROGueENEMY installed/updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_ROGUE" ]; then
	cd $HOME
	
	curl -sSL https://raw.githubusercontent.com/corando98/ROGueENEMY/main/chimera_uninstall.sh | sudo sh

	zenity --info --title "Legion Go Tools for Linux" --text "ROGueENEMY uninstalled!" --width 400 --height 75

elif [ "$Choice" == "HHD" ]; then
	cd $HOME
	
	# get needed dev tools
	sudo pacman -S --needed --noconfirm base-devel
	
	# remove HHD cloned repo folder if it already exists
	sudo rm -rf hhd/
	
	echo -e "Installing HHD...\n"
	git clone https://aur.archlinux.org/hhd.git
	cd hhd/
	makepkg -si --noconfirm
	
	# need to uninstall handygccs since it will conflict with HHD
	echo -e "Uninstalling handygccs-git...\n"
	sudo pacman -R --noconfirm handygccs-git
	
	# add PlayStation driver quirk. This will use Steam Input instead of the PS driver - we'll have touchpad issues otherwise
	echo -e "Blacklisting hid_playstation...\n"
	echo "blacklist hid_playstation" | sudo tee /usr/lib/modprobe.d/hhd.conf
	echo -e "hid_playstation blacklisted!\n"
	
	echo -e "Enabling HHD service...\n"
	sudo systemctl enable hhd@$(whoami)
	
	zenity --info --title "Legion Go Tools for Linux" --text "HHD has been installed/upgraded! (Note: you will need to restart your computer for the changes to take effect.)" --width 400 --height 75
	
elif [ "$Choice" == "UNINSTALL_HHD" ]; then
	cd $HOME
	
	echo -e "Stopping HHD service...\n"
	sudo systemctl disable hhd@$(whoami)
	
	echo -e "Installing handygccs-git...\n"
	rm -rf handygccs-git/
	git clone https://aur.archlinux.org/handygccs-git.git
	cd handygccs-git/
	makepkg -si --noconfirm
	
	echo -e "Uninstalling HHD...\n"
	sudo pacman -R --noconfirm hhd
	
	echo -e "Enabling handycon service...\n"
	sudo systemctl enable handycon.service
	
	zenity --info --title "Legion Go Tools for Linux" --text "HHD has been uninstalled! Restart for changes to take effect." --width 400 --height 75

elif [ "$Choice" == "STEAM_PATCH" ]; then
	cd $HOME
	
	curl -L https://github.com/corando98/steam-patch/raw/main/install.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been installed!" --width 400 --height 75

elif [ "$Choice" == "UPDATE_STEAM_PATCH" ]; then
	cd $HOME/steam-patch/
	
	echo -e "Fetching the latest git...\n"
	git pull
	
	echo -e "Upgrading steam-patch...\n"
	cargo build --release --target x86_64-unknown-linux-gnu
	sudo mv $HOME/steam-patch/target/x86_64-unknown-linux-gnu/release/steam-patch /usr/bin/steam-patch && sudo systemctl restart steam-patch.service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_STEAM_PATCH" ]; then
	cd $HOME
	
	curl -L https://raw.githubusercontent.com/corando98/steam-patch/main/uninstall.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been uninstalled!" --width 400 --height 75

elif [ "$Choice" == "LEGOTHEME" ]; then
	zenity --warning --title "Legion Go Tools for Linux" --text "Make sure you have the CSS Loader plugin installed before proceeding!" --width 400 --height 75
	
	echo -e "Downloading Legion Go theme for CSS Loader...\n"
	cd $HOME/homebrew/themes
	
	# remove folder if it was previously downloaded
	rm -rf SBP-Legion-Go-Theme/
	
	git clone https://github.com/frazse/SBP-Legion-Go-Theme.git
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go theme has been installed! Enable it via the CSS Loader plugin." --width 400 --height 75

elif [ "$Choice" == "PS5toXBOX" ]; then
	zenity --warning --title "Legion Go Tools for Linux" --text "Make sure you have the CSS Loader plugin installed before proceeding!" --width 400 --height 75

	echo -e "Downloading Xbox controller glyphs...\n"
	cd $HOME/homebrew/themes 
	
	# remove if previously downloaded
	rm -rf PS5-to-Xbox-glyphs/
	
	git clone https://github.com/frazse/PS5-to-Xbox-glyphs
	
	zenity --info --title "Legion Go Tools for Linux" --text "Xbox controller glyph theme has been installed! Enable it via the CSS Loader plugin." --width 400 --height 75

fi
done
