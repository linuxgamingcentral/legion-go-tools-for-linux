#!/bin/bash

clear

echo -e "Legion Go Tools for Linux - script by Linux Gaming Central\n"

unlock_filesystem() {
	echo -e "Unlocking file system...\n"
	echo -e "$PASS\n" | sudo frzr-unlock
	echo -e "Unlocked!\n"
}

restart_plugin_service() {
	echo -e "Restarting plugin service...\n"
	sudo systemctl restart plugin_loader.service
	echo -e "Restarted!\n"
}

install_build_tools() {
	echo -e "Installing pnpm..."
	# if pnpm not already installed
	sudo npm install -g pnpm
	pnpm install
	pnpm update decky-frontend-lib --latest
	
	echo -e "Building...\n"
	pnpm run build
}

# if user isn't running script as root, ask for password
if (( $EUID != 0 )); then
	FINISHED="false"
	while [ "$FINISHED" != "true" ]; do
		PASS=$(zenity --title="Legion Go Tools for Linux" --width=300 --height=100 --entry --hide-text --text="Enter your sudo/admin password:")
		if [[ $? -eq 1 ]] || [[ $? -eq 5 ]]; then
			exit 1
		fi
		if ( echo "$PASS" | sudo -S -k true ); then
			FINISHED="true"
			#echo "$PASS" | sudo -S -k bash "$0" "$@" # rerun script as root
			#exit 1
		else
			zenity --title="Legion Go Tools for Linux" --width=150 --height=40 --warning --text "Incorrect password."
		fi
	done
fi

unlock_filesystem

while true; do
Choice=$(zenity --width 1000 --height 600 --list --radiolist --multiple --title "Legion Go Tools for Linux"\
	--column "Select One" \
	--column "Option" \
	--column="Description"\
	FALSE DECKY "Install Decky Loader"\
	FALSE UNINSTALL_DECKY "Uninstall Decky Loader"\
	FALSE TDP "Install the Simple Decky TDP plugin"\
	FALSE UPDATE_TDP "Update the Simple Decky TDP plugin"\
	FALSE UNINSTALL_TDP "Uninstall the Simple Decky TDP plugin"\
	FALSE RGB "Install the RGB Decky plugin"\
	FALSE UPDATE_RGB "Update the RGB Decky plugin"\
	FALSE UNINSTALL_RGB "Uninstall the RGB Decky plugin"\
	FALSE ROGUE "Install ROGueENEMY"\
	FALSE UPDATE_ROGUE "Update ROGueENEMY"\
	FALSE UNINSTALL_ROGUE "Uninstall ROGueENEMY"\
	FALSE HHD "Install or Update Handheld Daemon (HHD)"\
	FALSE UNINSTALL_HHD "Uninstall Handheld Daemon (HHD)"\
	FALSE STEAM_PATCH "Install Steam-Patch"\
	FALSE UPDATE_STEAM_PATCH "Update Steam-Patch"\
	FALSE UNINSTALL_STEAM_PATCH "Uninstall Steam-Patch"\
	FALSE LEGOTHEME "Install the Legion Go theme for CSS Loader"\
	FALSE PS5toXBOX "Install the Xbox controller glyph theme for CSS Loader (recommended after installing HHD)"\
	TRUE EXIT "Exit this script")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]; then
	echo Goodbye!
	exit

elif [ "$Choice" == "DECKY" ]; then
	cd /home/gamer/

	curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Decky Loader installation complete!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_DECKY" ]; then
	cd /home/gamer/

	curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Decky Loader uninstallation complete!" --width 400 --height 75

elif [ "$Choice" == "TDP" ]; then
	cd /home/gamer/

	# remove the cloned repo if it already exists
	echo -e "Removing existing cloned repo...\n"
	rm -r -f SimpleDeckyTDP/
	echo -e "Deleted!\n"
	
	echo -e "Cloning repo...\n"
	git clone https://github.com/aarron-lee/SimpleDeckyTDP.git
	cd SimpleDeckyTDP/
	
	install_build_tools
	
	cd ..
	echo -e "Copying plugin...\n"
	chmod -R 777 /home/gamer/homebrew/plugins/
	cp -r SimpleDeckyTDP/ /home/gamer/homebrew/plugins/
	
	restart_plugin_service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Simple Decky TDP plugin installed!" --width 400 --height 75

elif [ "$Choice" == "UPDATE_TDP" ]; then
	cd /home/gamer/homebrew/plugins/SimpleDeckyTDP/
	echo -e "Fetching the latest git...\n"
	git pull
	
	install_build_tools
	
	restart_plugin_service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Simple Decky TDP updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_TDP" ]; then
	echo -e "Removing folder...\n"
	sudo rm -r -f /home/gamer/homebrew/plugins/SimpleDeckyTDP/
	
	restart_plugin_service

	zenity --info --title "Legion Go Tools for Linux" --text "Simple Decky TDP removed!" --width 400 --height 75

elif [ "$Choice" == "RGB" ]; then
	cd /home/gamer/
	
	# remove the cloned repo if it already exists
	echo -e "Removing existing cloned repo...\n"
	rm -r -f LegionGoRemapper/
	echo -e "Deleted!\n"
	
	echo -e "Removing python-hidapi...\n"
	sudo pacman -R --noconfirm python-hidapi -d -d # remove python-hidapi first, since it will conflict with python-hid
	echo -e "Removed!\n"
	
	echo -e "Installing python-hid...\n"
	sudo pacman -S --noconfirm python-hid
	echo -e "Installed!\n"
	
	# add udev rules
	echo -e "Adding udev rules...\n"
	sudo touch /etc/udev/rules.d/99-usb-tweak.rules
	echo -e "SUBSYSTEMS=="usb", ATTRS{idVendor}=="17ef", TAG+="uaccess" \nSUBSYSTEMS=="usb", ATTRS{idVendor}=="17ef", GROUP="plugdev", MODE="0660"  \nSUBSYSTEMS=="usb", ATTRS{idVendor}=="17ef", MODE="0666"" | sudo tee -a /etc/udev/rules.d/99-usb-tweak.rules
	
	echo -e "Reloading udev rules...\n"
	sudo udevadm control --reload
	
	echo -e "Cloning LegionGoRemapper repo...\n"
	git clone https://github.com/aarron-lee/LegionGoRemapper.git
	cd LegionGoRemapper
	
	install_build_tools
	
	cd ..
	echo -e "Copying plugin to ~/homebrew/plugins/...\n"
	sudo cp -r LegionGoRemapper/ /home/gamer/homebrew/plugins/
	
	restart_plugin_service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go Remapper plugin installed!" --width 400 --height 75

elif [ "$Choice" == "UPDATE_RGB" ]; then
	cd /home/gamer/homebrew/plugins/LegionGoRemapper/
	echo -e "Fetching the latest git...\n"
	git pull
	
	install_build_tools
	
	restart_plugin_service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go Remapper plugin updated!" --width 400 --height 75
	
elif [ "$Choice" == "UNINSTALL_RGB" ]; then
	echo -e "Removing LegionGoRemapper folder...\n"
	sudo rm -r -f /home/gamer/homebrew/plugins/LegionGoRemapper/

	restart_plugin_service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go Remapper plugin removed!" --width 400 --height 75

elif [ "$Choice" == "ROGUE" ]; then
	cd /home/gamer/
	
	rm -r -f ROGueENEMY/
	sudo pacman -S --needed --noconfirm base-devel cmake libconfig libevdev
	
	git clone https://github.com/corando98/ROGueENEMY.git
	cd ROGueENEMY/
	sudo bash chimera_install.sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "ROGueENEMY installed!" --width 400 --height 75

elif [ "$Choice" == "UPDATE_ROGUE" ]; then
	cd /home/gamer/ROGueENEMY/
	git pull
	
	sudo bash chimera_install.sh
		
	zenity --info --title "Legion Go Tools for Linux" --text "ROGueENEMY updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_ROGUE" ]; then
	echo -e "Uninstalling...\n"
	sudo bash /home/gamer/ROGueENEMY/chimera_uninstall.sh
		
	zenity --info --title "Legion Go Tools for Linux" --text "ROGueENEMY uninstalled!" --width 400 --height 75

elif [ "$Choice" == "HHD" ]; then
	cd /home/gamer/
	
	# get needed dev tools
	sudo pacman -S --needed --noconfirm base-devel
	
	# remove HHD cloned repo folder if it already exists
	sudo rm -r -f hhd/
	
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
	cd /home/gamer/
	
	echo -e "Stopping HHD service...\n"
	sudo systemctl disable hhd@$(whoami)
	
	echo -e "Installing handygccs-git...\n"
	rm -r -f handygccs-git/
	git clone https://aur.archlinux.org/handygccs-git.git
	cd handygccs-git/
	makepkg -si --noconfirm
	
	echo -e "Uninstalling HHD...\n"
	sudo pacman -R --noconfirm hhd
	
	echo -e "Enabling handycon service...\n"
	sudo systemctl enable handycon.service
	
	zenity --info --title "Legion Go Tools for Linux" --text "HHD has been uninstalled! Restart for changes to take effect." --width 400 --height 75

elif [ "$Choice" == "STEAM_PATCH" ]; then
	cd /home/gamer/
	
	rm -r -f steam-patch/
	echo -e "Cloning steam-patch repo...\n"
	git clone https://github.com/corando98/steam-patch.git
	cd steam-patch
	
	echo -e "Installing...\n"
	sudo bash install.sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been installed!" --width 400 --height 75

elif [ "$Choice" == "UPDATE_STEAM_PATCH" ]; then
	cd /home/gamer/steam-patch/
	
	echo -e "Fetching the latest git...\n"
	git pull
	
	echo -e "Upgrading steam-patch...\n"
	cargo build --release --target x86_64-unknown-linux-gnu
	sudo mv ~/steam-patch/target/x86_64-unknown-linux-gnu/release/steam-patch /usr/bin/steam-patch && sudo systemctl restart steam-patch.service
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been updated!" --width 400 --height 75

elif [ "$Choice" == "UNINSTALL_STEAM_PATCH" ]; then
	cd /home/gamer/steam-patch/
	
	echo -e "Uninstalling steam-patch...\n"
	sudo bash uninstall.sh
	
	zenity --info --title "Legion Go Tools for Linux" --text "Steam-Patch has been uninstalled!" --width 400 --height 75

elif [ "$Choice" == "LEGOTHEME" ]; then
	zenity --warning --title "Legion Go Tools for Linux" --text "Make sure you have the CSS Loader plugin installed before proceeding!" --width 400 --height 75
	
	echo -e "Downloading Legion Go theme for CSS Loader...\n"
	cd /home/gamer/homebrew/themes && git clone https://github.com/frazse/SBP-Legion-Go-Theme.git
	
	zenity --info --title "Legion Go Tools for Linux" --text "Legion Go theme has been installed! Enable it via the CSS Loader plugin." --width 400 --height 75

elif [ "$Choice" == "PS5toXBOX" ]; then
	zenity --warning --title "Legion Go Tools for Linux" --text "Make sure you have the CSS Loader plugin installed before proceeding!" --width 400 --height 75

	echo -e "Downloading Xbox controller glyphs...\n"
	cd /home/gamer/homebrew/themes && git clone https://github.com/frazse/PS5-to-Xbox-glyphs
	
	zenity --info --title "Legion Go Tools for Linux" --text "Xbox controller glyph theme has been installed! Enable it via the CSS Loader plugin." --width 400 --height 75

fi
done
