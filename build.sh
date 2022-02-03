#!/usr/bin/env bash
if [ -d "build" ]; then
  # Take action if $DIR exists. #
    echo "BUILD EXISTS"
else 
    mkdir build
fi

cd build
/home/liam/Documents/Qt/5.15.2/gcc_64/bin/qmake ~/Documents/qgroundcontrol/qgroundcontrol.pro
make -j$1
