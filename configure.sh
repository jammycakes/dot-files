#! /usr/bin/env bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/lib/detect.sh

cd $DIR
git submodule update --init --recursive

# ====== Create backup folders ====== #

if ! [ -f ~/.dotfiles-backup/home ]; then
    mkdir -p ~/.dotfiles-backup/home
fi
if ! [ -f ~/.dotfiles-backup/files ]; then
    mkdir -p ~/.dotfiles-backup/files
fi

# ====== OS-specific preinstall script ====== #

if [ -f $DIR/$TARGET_OS/pre-configure.sh ]; then
    . $DIR/$TARGET_OS/pre-configure.sh
fi

# ====== Symlink all dotfiles and dotfolders into root directory ====== #

for I in $(ls -A "$DIR/home")
do
    if [ -e ~/$I ]; then
        if ! [ -e ~/.dotfiles-backup/home/$I ]; then
            echo Backing up $I to .dotfiles-backup/home
            mv ~/$I ~/.dotfiles-backup/home
        else
            rm ~/$I
        fi
    fi
    ln -s "$DIR/home/$I" ~/$I
done

# ====== Additional folders to append to path ====== #

mkdir -p ~/.bin
if ! [ -e ~/.bin/dotfiles ]; then
    ln -s "$DIR/bin" ~/.bin/dotfiles
fi

# ====== Do the apps directory ====== #

for i in $(ls -A "$DIR/apps")
do
    if [ -f "$DIR/apps/$i/install.sh" ]; then
        echo "Installing $i"
        "$DIR/apps/$i/install.sh"
    fi
    if [ -f "$DIR/apps/$i/install.$TARGET_OS.sh" ]; then
        echo "Installing $i for $TARGET_OS"
        "$DIR/apps/$i/install.$TARGET_OS.sh"
    fi
done

# ====== OS-specific post-install script ====== #

if [ -f "$DIR/$TARGET_OS/configure.sh" ]; then
    . "$DIR/$TARGET_OS/configure.sh"
fi
