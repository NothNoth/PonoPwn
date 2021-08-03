#!/bin/bash -e
if ! [ "$1" ]; then
    echo "Usage: $0 <OTA package to create from ./decompiled/ folder>"
    echo "Example: $0 pono_1.0.6.update"
    exit -1
fi

pkg=${1}

rm -f $pkg.repacked $pkg.repacked.signed $pkg.ready
rm -rf decompiled/build
rm -f decompiled/original/META-INF/CERT.SF
rm -f decompiled/original/META-INF/CERT.RSA
rm -f decompiled/original/META-INF/MANIFEST.MF

apktool b -c -f decompiled/ -o $pkg.repacked

echo "Signing..."
java -jar signapk-1.0.jar -w 2.3.6-testkeys/testkey.x509.pem 2.3.6-testkeys/testkey.pk8 ${pkg}.repacked ${pkg}.repacked.signed
mv $pkg.repacked.signed $pkg

rm -f $pkg.repacked
echo "Updated OTA package ready: $pkg"