#!/bin/env bash

#TOOLCHAIN_DIR="$HOME"/Dev/351ELEC/build.351ELEC-RG351V.aarch64/toolchain
VERSION="1.0"

set -eE

# $1: DEVICE
# $2: FIRMWARE
# $3: START_PATH
# $4: RES_PATH
PASS="0"
build351Files() {
   DEVICE="$1"
   FIRMWARE="$2"
   START_PATH="$3"
   RES_PATH="$4"
   make clean
   make CC=g++ DEVICE="$DEVICE" SDL2_CONFIG=sdl2-config START_PATH="$START_PATH" RES_PATH="$RES_PATH" -j$(nproc)
   strip 351Files
   mkdir -p build/351Files
   cp -r 351Files README.md res build/351Files
   if [[ -e 351Files-sd2.tmp ]]; then
     cp -r 351Files-sd2.tmp build/351Files/351Files-sd2
   fi
   cp launchers/"$FIRMWARE"/351Files.sh build
   cd build
   tar zcf 351Files-"$VERSION"_"$DEVICE"_"$FIRMWARE".tgz 351Files.sh 351Files
   rm -rf 351Files.sh 351Files 351Files-sd2
   cd ..
}

# Clean up previous builds
rm -rf build

# Build for 351MP, 351ELEC
#build351Files RG351MP 351ELEC /storage/roms ./res

# Build for 351V, 351ELEC
#build351Files RG351V 351ELEC /storage/roms ./res

# Build for 351P, 351ELEC
#build351Files RG351P 351ELEC /storage/roms ./res

# Build for 351V, ArkOS
#build351Files RG351V ArkOS /roms ./res

# Build for 351P, ArkOS
#build351Files RG351P ArkOS /roms ./res

# Build for 351MP, ArkOS
#build351Files RG351MP ArkOS /roms ./res

# Build for RGB10, ArkOS
#build351Files RGB10 ArkOS /roms ./res

# Build for RK2020, ArkOS
#build351Files RK2020 ArkOS /roms ./res

# Build for CHI, ArkOS
#build351Files CHI ArkOS /roms ./res

if [[ "${1}" == "RGB30" ]] || [[ "${1}" == "RG351V" ]] || [[ "${1}" == "RG351MP" ]] || [[ "${1}" == "RG353V" ]] || [[ "${1}" == "RG503" ]]; then
  build351Files "$1" "$2" "/roms2" "$4"
  mv -f 351Files 351Files-sd2.tmp
  build351Files "$1" "$2" "/roms" "$4"
  mv -f 351Files-sd2.tmp 351Files-sd2
else
  build351Files "$1" "$2" "$3" "$4"
fi
