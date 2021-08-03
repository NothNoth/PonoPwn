#!/bin/bash -e
if ! [ "$1" ]; then
    echo "Usage: $0 <OTA package to extract>"
    echo "Example: $0 pono_1.0.6.update"
    exit -1
fi


rm -rf decompiled
apktool d -f $1 -o decompiled
echo "Extracted to ./decompiled/."

