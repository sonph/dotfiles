#!/bin/bash

DIR="home"

for file in $(ls $DIR); do
    ln -s $PWD/$DIR/$file ~/.${file}
done
