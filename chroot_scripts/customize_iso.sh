#! /bin/bash
CHROOT_SCRIPTS_PATH='/root/chroot_scripts'
DEB_PATH='$CHROOT_SCRIPTS_PATH/deb'

custom_echo() {
    echo -e "\e[1;31m $1 \e[0m"
}

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

custom_echo "add i386 architecture"
sudo dpkg --add-architecture i386

# Add apt repository
custom_echo "update apt-get"
sudo add-apt-repository -y ppa:fcitx-team/nightly
sudo add-apt-repository -y ppa:wine/wine-builds
sudo apt-get update

sudo apt-get -y install aptitude --allow-unauthenticated
sudo apt-get -y install git --allow-unauthenticated

# install docky
#custom_echo "instaling docky"
#sudo apt-get -y install docky --allow-unauthenticated

# install fcitx
custom_echo "instaling fcitx"
sudo apt-get -y remove scim
sudo apt-get -y install fcitx --allow-unauthenticated
custom_echo "switching fcitx"
sudo im-switch -s fcitx -z default

# delete amazon
custom_echo "removing amazon"
sudo apt-get -y remove unity-webapps-common
# delete firefox
custom_echo "removing firefox"
sudo apt-get -y remove firefox

# install wine
custom_echo "installing wine"
#sudo apt-get -y install winehq-devel

# install MC
custom_echo "instaling mc"
sudo apt-get install -y openjdk-8-jdk --allow-unauthenticated
cp -ra $CHROOT_SCRIPTS_PATH/mc /opt/

# install theme
custom_echo "instaling theme"
rm -rf /usr/share/themes/Ambiance
cp -r $CHROOT_SCRIPTS_PATH/OSXTheme/Ambiance /usr/share/themes/

# install icon theme
rm -rf /usr/share/icons/ubuntu-mono-dark/
cp -r $CHROOT_SCRIPTS_PATH/OSXTheme/ubuntu-mono-dark /usr/share/icons/

# Change background
custom_echo "changing background"
cp -r $CHROOT_SCRIPTS_PATH/backgrounds/* /usr/share/backgrounds/
cp -r $CHROOT_SCRIPTS_PATH/com.canonical.unity-greeter.gschema.xml /usr/share/glib-2.0/schemas/
cp -r $CHROOT_SCRIPTS_PATH/ubuntu-wallpapers.xml /usr/share/gnome-background-properties/
cp -r $CHROOT_SCRIPTS_PATH/%gconf-tree.xml /var/lib/gconf/debian.defaults/

# Change Launcher bfb
cp -r $CHROOT_SCRIPTS_PATH/launcher_bfb.png /usr/share/unity/icons/ 
cp -r $CHROOT_SCRIPTS_PATH/org.gnome.desktop.background.gschema.xml /usr/share/glib-2.0/schemas/

# Change GTK-Theme
# Change Icon-Theme
cp -r $CHROOT_SCRIPTS_PATH/com.canonical.Unity.gschema.xml /usr/share/glib-2.0/schemas/
cp -r $CHROOT_SCRIPTS_PATH/*.desktop /usr/share/applications/

# Hide launcher
#cp -r $CHROOT_SCRIPTS_PATH/org.compiz.unityshell.gschema.xml /usr/share/glib-2.0/schemas/

glib-compile-schemas /usr/share/glib-2.0/schemas

# Install zh-hans language support
custom_echo "installing zh-hans language support"
sudo apt-get -y install `check-language-support -l zh-hans`
sudo apt-get -y install language-pack-zh-hans
sudo cp $CHROOT_SCRIPTS_PATH/locale /etc/default/locale
sudo fc-cache -f -v

# Install debs
custom_echo "installing debs"
for deb in $CHROOT_SCRIPTS_PATH/deb/*.deb; do
    sudo dpkg -i $deb
done

# Install sougou skin
mkdir -p /usr/share/sogou-qimpanel/
sudo cp -r $CHROOT_SCRIPTS_PATH/sougou/* /usr/share/sogou-qimpanel/skin

sudo cp -r $CHROOT_SCRIPTS_PATH/*release /etc/
sudo apt-get remove -y sunpinyin-data
sudo apt-get remove -y fcitx-sunpinyin
sudo apt-get -fy install


#cleanup
custom_echo "clean up"
. ${CHROOT_SCRIPTS_PATH}/cleanup.sh
