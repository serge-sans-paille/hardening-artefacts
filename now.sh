#!bin/sh
set -e
set -x

LINKERS="ld lld"
CC=clang
READELF=readelf

cat > now.c <<EOF
#include <stdio.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for linker in $LINKERS
do
    $CC -o lazy now.c -Wl,-z,lazy -fuse-ld=$linker
    $READELF -a lazy | { ! grep BIND_NOW ;}

    $CC -o now now.c -Wl,-z,now -fuse-ld=$linker
    $READELF -a now | grep BIND_NOW

done

rm now.c lazy now
