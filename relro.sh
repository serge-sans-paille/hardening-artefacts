#!bin/sh
set -e
set -x

LINKERS="ld lld"
CC=clang
READELF=readelf

cat > relro.c <<EOF
#include <stdio.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for linker in $LINKERS
do
    $CC -o norelro relro.c -Wl,-z,norelro -fuse-ld=$linker
    $READELF --segments norelro | { ! grep GNU_RELRO ;}

    $CC -o relro relro.c -Wl,-z,relro -fuse-ld=$linker
    $READELF --segments relro | grep GNU_RELRO

done

rm relro.c relro norelro
