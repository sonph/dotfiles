#!/bin/bash

DIR="home"

for file in $(ls $DIR); do
    ln -s $PWD/$DIR/$file $HOME/.${file}
done

ln -s $PWD/bin $HOME/bin
