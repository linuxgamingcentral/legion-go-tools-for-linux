#!/bin/bash

clear

echo -e "Legion Go Tools for Linux - script by Linux Gaming Central\n"

# Removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

# zenity functions
info() {
	i=$1
	zen_nospam --info --title "$title" --width 400 --height 75 --text "$1"
}

warning() {
	i=$1
	zen_nospam --warning --title "$title" --width 400 --height 75 --text "$1"
}

error() {
	e=$1
	zen_nospam --error --title="$title" --width=400 --height=75 --text "$1"
}

# functions
get_sudo_password() {
	sudo_password=$(zen_nospam --password --title="$title")
	if [[ ${?} != 0 || -z ${sudo_password} ]]; then
		echo -e "User canceled.\n"
		exit
	elif ! sudo -kSp '' [ 1 ] <<<${sudo_password} 2>/dev/null; then
		echo -e "User entered wrong password.\n"
		error "Wrong password."
		exit
	else
		echo -e "Password entered, let's proceed...\n"
	fi
}

title="Legion Go Tools for Linux"

get_sudo_password

# unlock filesystem if we're using ChimeraOS
if [ $USER == "gamer" ]; then
	echo -e "Unlocking file system...\n"
	sudo -Sp '' frzr-unlock<<<${sudo_password}
	echo -e "Unlocked!\n"
fi

cd $HOME

while true; do
Choice=$(zen_nospam --width 1000 --height 700 --list --radiolist --multiple --title "$title"\
	--column "Select One" \
	--column "Option" \
	--column="Description"\
	FALSE DECKY "Install Decky Loader"\
	FALSE TDP "Install or Update the Simple Decky TDP plugin"\
	FALSE RGB "Install or Update the LegionGoRemapper plugin"\
	FALSE HHD "Install or Update Handheld Daemon (HHD)"\
	FALSE HHD_DECKY "Install or Update HHD plugin"\
	FALSE STEAM_PATCH "Install Steam-Patch (warning: currently buggy!)"\
	FALSE UPDATE_STEAM_PATCH "Update Steam-Patch"\
	FALSE LEGOTHEME "Install the Legion Go theme for CSS Loader"\
	FALSE PS5toXBOX "Install the Xbox controller glyph theme for CSS Loader (recommended after installing HHD)"\
	FALSE UNINSTALL "Head to the Uninstall sub-menu"\
	TRUE EXIT "Exit this script")

	if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]; then
		echo Goodbye!
		exit

	elif [ "$Choice" == "DECKY" ]; then
		curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
		
		info "Decky Loader installation complete!"

	elif [ "$Choice" == "TDP" ]; then
		echo -e "Installing plugin...\n"
		curl -L https://raw.githubusercontent.com/aarron-lee/SimpleDeckyTDP/main/install.sh | sh
		
		info "Simple Decky TDP plugin installed/updated!" 

	elif [ "$Choice" == "RGB" ]; then
		echo -e "Installing plugin...\n"
		curl -L https://raw.githubusercontent.com/aarron-lee/LegionGoRemapper/main/install.sh | sh
		
		info "Legion Go Remapper plugin installed/updated!"

	elif [ "$Choice" == "HHD" ]; then
		if [ $USER == "gamer" ]; then
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
			#echo -e "Blacklisting hid_playstation...\n"
			#echo "blacklist hid_playstation" | sudo tee /usr/lib/modprobe.d/hhd.conf
			#echo -e "hid_playstation blacklisted!\n"
			
			echo -e "Enabling HHD service...\n"
			sudo systemctl enable hhd@$(whoami)
			
			info "HHD has been installed/upgraded! (Note: you will need to restart your computer for the changes to take effect.)"
		else
			info "Currently this function only works on ChimeraOS."
		fi 

	elif [ "$Choice" == "HHD_DECKY" ]; then
		if ! [ -f $HOME/.config/hhd/state.yml ]; then
			error "state.yml file not found, you may not have HHD installed yet."
		else
			curl -L https://github.com/hhd-dev/hhd-decky/raw/main/install.sh | sh
			
			info "HHD Decky plugin installed/updated!"
			info "Note: you will need to change 'enable' to 'true' under 'http' in $HOME/.config/hhd/state.yml"
		fi		
	
	elif [ "$Choice" == "STEAM_PATCH" ]; then
		curl -L https://github.com/corando98/steam-patch/raw/main/install.sh | sh
		
		info "Steam-Patch has been installed!" 

	elif [ "$Choice" == "UPDATE_STEAM_PATCH" ]; then
		cd $HOME/steam-patch/
		
		echo -e "Fetching the latest git...\n"
		git pull
		
		echo -e "Upgrading steam-patch...\n"
		cargo build --release --target x86_64-unknown-linux-gnu
		sudo mv $HOME/steam-patch/target/x86_64-unknown-linux-gnu/release/steam-patch /usr/bin/steam-patch && sudo systemctl restart steam-patch.service
		
		info "Steam-Patch has been updated!"
		
		cd $HOME 

	elif [ "$Choice" == "LEGOTHEME" ]; then
		warning "Make sure you have the CSS Loader plugin installed before proceeding!" 
		
		echo -e "Downloading Legion Go theme for CSS Loader...\n"
		cd $HOME/homebrew/themes
		
		# remove folder if it was previously downloaded
		rm -rf SBP-Legion-Go-Theme/
		
		git clone https://github.com/frazse/SBP-Legion-Go-Theme.git
		
		info "Legion Go theme has been installed! Enable it via the CSS Loader plugin."
		
		cd $HOME 

	elif [ "$Choice" == "PS5toXBOX" ]; then
		warning "Make sure you have the CSS Loader plugin installed before proceeding!" 

		echo -e "Downloading Xbox controller glyphs...\n"
		cd $HOME/homebrew/themes 
		
		# remove if previously downloaded
		rm -rf PS5-to-Xbox-glyphs/
		
		git clone https://github.com/frazse/PS5-to-Xbox-glyphs
		
		info "Xbox controller glyph theme has been installed! Enable it via the CSS Loader plugin." 
		
		cd $HOME
	
	elif [ "$Choice" == "UNINSTALL" ]; then
		while true; do
		Choice=$(zen_nospam --width 1000 --height 500 --list --radiolist --multiple --title "$title"\
			--column "Select One" \
			--column "Option" \
			--column="Description"\
			FALSE UNINSTALL_DECKY "Uninstall Decky Loader"\
			FALSE UNINSTALL_TDP "Uninstall the Simple Decky TDP plugin"\
			FALSE UNINSTALL_RGB "Uninstall the LegionGoRemapper plugin"\
			FALSE UNINSTALL_HHD "Uninstall Handheld Daemon (HHD)"\
			FALSE UNINSTALL_STEAM_PATCH "Uninstall Steam-Patch"\
			TRUE EXIT "Close this sub-menu")

			if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]; then
				break
			
			elif [ "$Choice" == "UNINSTALL_DECKY" ]; then
				curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
				
				info "Decky Loader uninstallation complete!"
			
			elif [ "$Choice" == "UNINSTALL_TDP" ]; then
				if [ "$EUID" -eq 0 ]; then
					echo "Please do not run as root"
			  		exit
				fi

				if ! [ -d $HOME/homebrew/plugins/SimpleDeckyTDP ]; then
					error "SimplDeckyTDP plugin not found."
				else
					sudo rm -rf $HOME/homebrew/plugins/SimpleDeckyTDP
				
					sudo systemctl restart plugin_loader.service

					info "Simple Decky TDP removed!" 
				fi
					
			elif [ "$Choice" == "UNINSTALL_RGB" ]; then
				if [ "$EUID" -eq 0 ]
					then echo "Please do not run as root"
					exit
				fi
				
				if ! [ -d $HOME/homebrew/plugins/LegionGoRemapper ]; then
					error "LegionGoRemapper plugin not found."
				else
					sudo rm -rf $HOME/homebrew/plugins/LegionGoRemapper
				
					sudo systemctl restart plugin_loader.service
				
					info "Legion Go Remapper plugin removed!"
				fi
			
			elif [ "$Choice" == "UNINSTALL_HHD" ]; then
				if [ $USER == "gamer" ]; then
					echo -e "Stopping HHD service...\n"
					sudo systemctl disable hhd@$(whoami)
					
					echo -e "Installing handygccs-git...\n"
					rm -rf handygccs-git/
					git clone https://aur.archlinux.org/handygccs-git.git
					cd handygccs-git/
					makepkg -si --noconfirm
					
					echo -e "Uninstalling HHD...\n"
					sudo pacman -R --noconfirm hhd
					sudo rm /etc/udev/modprobe.d/hhd.conf
					rm -rf $HOME/.config/hhd
					
					echo -e "Enabling handycon service...\n"
					sudo systemctl enable handycon.service
					
					info "HHD has been uninstalled! Restart for changes to take effect."
				else
					info "Currently this function only works on ChimeraOS."
				fi
			
			elif [ "$Choice" == "UNINSTALL_STEAM_PATCH" ]; then
				curl -L https://raw.githubusercontent.com/corando98/steam-patch/main/uninstall.sh | sh
				
				info "Steam-Patch has been uninstalled!"
			fi
		done
	fi
done
