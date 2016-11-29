#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ====== Symlink all dotfiles and dotfolders into root directory ====== #

for I in $(ls -A | grep -v -e "^\.git\(ignore\|attributes\)\?$" | grep ^\\.)
do
    if [ -f ~/$I ] || [ -h ~/$I ]; then
        rm ~/$I
    fi
    ln -s $DIR/$I ~/$I
done

# ====== Configure vim ====== #

if ! [ -d $DIR/.vim/bundle ]; then
    mkdir -p $DIR/.vim/bundle
    git clone https://github.com/gmarik/vundle $DIR/.vim/bundle/vundle
    vim -C +PluginInstall +qa!
fi

# ====== Append to path ====== #

mkdir -p ~/.bin
ln -s $DIR/bin ~/.bin/dotfiles
