# Legion Go Tools for Linux
This script takes a bunch of community-made tools for the Legion Go and mashes them together into one convenient location. Install, update, and/or uninstall the following:
- [Decky Loader](https://github.com/SteamDeckHomebrew/decky-loader)
- [SimpleDeckyTDP plugin](https://github.com/aarron-lee/SimpleDeckyTDP) - adjust TDP with a Decky plugin
- [LegionGoRemapper plugin](https://github.com/aarron-lee/LegionGoRemapper/) - adjust RGBs around the sticks, and remap back buttons
- [ROGueENEMY](https://github.com/corando98/ROGueENEMY/) - DualSense emulator
- [Handheld Daemon](https://github.com/antheas/hhd) - basically an enhanced version of ROGueENEMY
- [steam-patch](https://github.com/corando98/steam-patch) - fixes TDP and GPU clock speed in QAM, and replaces Steam's button icons to give it a more consistent look
- [Legion Go theme for CSS Loader](https://github.com/frazse/SBP-Legion-Go-Theme) - makes your controller profile actually look like a Legion Go
- [PS5 to Xbox controller glyphs for CSS Loader](https://github.com/frazse/PS5-to-Xbox-glyphs) - converts PS5 glyphs to Xbox; recommended after applying ROGueENEMY or HHD

![Screenshot from 2023-12-15 15-22-49](https://github.com/linuxgamingcentral/legion-go-tools-for-linux/assets/101075966/bd2a6b57-e549-45ba-804e-abe92901f8bb)

This script is very buggy and you will likely not be able to install everything you need (such as steam-patch). You'll need to enter your sudo password twice. Additionally, the script is hard-coded to only work with ChimeraOS at the moment.

Download and run the script as follows:
```
git clone https://github.com/linuxgamingcentral/legion-go-tools-for-linux.git
cd legion-go-tools-for-linux/
chmod +x lego_chimera.sh
./lego_chimera.sh
```

Thanks go to the following:
- **Aarron Lee** for the TDP and LeGoRemapper plugins
- **corando98** for ROGueENEMY and steam-patch
- **Antheas** for HHD
- **frazse** for CSS loader themes
