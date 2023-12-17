# Legion Go Tools for Linux
This script takes a bunch of community-made tools for the Legion Go and mashes them together into one convenient location. Install, update, and/or uninstall the following:
- [Decky Loader](https://github.com/SteamDeckHomebrew/decky-loader)
- [SimpleDeckyTDP plugin](https://github.com/aarron-lee/SimpleDeckyTDP) - adjust TDP with a Decky plugin
- [LegionGoRemapper plugin](https://github.com/aarron-lee/LegionGoRemapper/) - adjust RGBs around the sticks, and remap back buttons
- [ROGueENEMY](https://github.com/corando98/ROGueENEMY/) - DualSense emulator
- [Handheld Daemon](https://github.com/antheas/hhd) - basically an enhanced version of ROGueENEMY
- [steam-patch](https://github.com/corando98/steam-patch) - fixes TDP and GPU clock speed in QAM, and replaces Steam's button icons to give it a more consistent look
- [Legion Go theme for CSS Loader](https://github.com/frazse/SBP-Legion-Go-Theme) - makes your controller profile actually look like a Legion Go
- [PS5 to Xbox controller glyphs for CSS Loader](https://github.com/frazse/PS5-to-Xbox-glyphs) - converts PS5 glyphs to Xbox; recommended after installing ROGueENEMY or HHD

![Screenshot from 2023-12-16 02-18-02](https://github.com/linuxgamingcentral/legion-go-tools-for-linux/assets/101075966/3df7e0a3-1912-4ab6-8beb-9b77601406c9)

This script is very buggy and you will likely not be able to install everything you need (such as steam-patch). It was primarily made with ChimeraOS in mind but it *may* be compatible with other Arch-based distros.

See my [post](https://linuxgamingcentral.com/posts/legion-go-tools-for-linux/) or the [Legion Go Tricks page](https://github.com/aarron-lee/legion-go-tricks) for more info.

## Install
Download and run the script with:

`curl -L https://raw.githubusercontent.com/linuxgamingcentral/legion-go-tools-for-linux/main/lego_chimera.sh | sh`

## If You're Installing Steam-Patch...
Installing steam-patch is a bit buggy right now, you might need to do the following after installing it:
1. `sudo systemctl stop steam-patch.service`
2. Download [steam-patch artifact](https://github.com/corando98/steam-patch/actions/runs/7017005010) and extract
3. `sudo cp steam-patch /usr/bin/`
4. `sudo systemctl restart steam-patch.service`

## Thanks Go To...
- **Aarron Lee** for the TDP and LeGoRemapper plugins
- **corando98** for ROGueENEMY and steam-patch
- **Antheas** for HHD
- **frazse** for CSS loader themes
