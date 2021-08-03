# PonoPwn

Tools for playing with the Pono Player firmware.

## A brief history

The Pono Player was released in 2015 and discontinued in 2017.
This is a great player in terms of audio quality, but the firmware was never great.

PonoPlayer runs on Android 2.2.3 (Gingerbread).

I tried to contact Neil Young (which was behind the projet) to get access to the Pono achives in order to open source it, and allow new un-official upgrades without much success.

So, this repository is the hacky way.

## Altering the firmware

The Pono Player firmware basically runs a very raw android with almost anything untouched, then starts player-release.apk. There's no way to quit this app so you won't have many opportunities to alter something.

I tried uncompiling the app and look for exploitable vulnerabilities with not much success.

Thus I tried to use the upgrade mechanism which is using OTA package.
Basically, an upgrade firmware is a signed APK put into a ".pono" folder on the internal storage. When found, the player-release.apk asks Android for verification and install.

The easy part is the OTA package extraction, we can test it with the last released firmware (1.0.6):

    apktool d -f pono_1.0.6.update -o decompiled

Now, the "decompiled/" folder contains everything that's included into the upgrade:

  - the upgrade script to be run ("decompiled/original/META-INF/com/google/android/updater-script") in edify format
  - the complete directoy tree to be deployed by this script

Read more about this here: https://source.android.com/devices/tech/ota/nonab/inside_packages?hl=en


Once decompiled, you may try to add new files, alter configuration and/or alter the updater-script to add new steps.

Then, you have to re-package it. Hopefully, the firmware uses the Android test keys for OTA package signature (I told you the firmware was never great.. :) ).
Basilly:

  - use apktool again to rebuild the apk (and keep the META-INF original files, thus the updater script)
  - sign the apk, using the Gingerbread Android test keys and the mandatoy "-w" option (which also signes the whole Apk, by setting a comment to the zip file)

## First test

There's a strong risk of bricking the device here, so I started with something really simple: altering the "unknown/system/etc/licenses.txt". Once upgraded, the content of the updated file in "Settings ->pono Player Info -> View Licences".

## Usage

__WARNING !__ As said previously, if your update fails you may deploy a corrupted firmware on your device, thus making it fully unusable. Since there's no adb shell, nor recovery boot, your PonoPlayer may be bricked. I am not responsible of this, you've been warned.

I provide a few scritp to help decompiling/recompiling a firmware.

### Decompiling:

Start from the last available firmware: "pono_1.0.6.update"

    ./decompile.sh pono_1.0.6.update

This will create a ./decompiled/ folder with the firmware contents.

### Recompiling

Use the compile.sh script:

    ./compile.sh pono_1.0.6.update

This will re-package and sign the ./decompiled/ folder.

