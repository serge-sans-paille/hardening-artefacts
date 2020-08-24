#!bin/sh
set -e
set -x

LINKERS="ld lld"
COMPILERS="clang"
READELF=readelf

cat > pie.c <<EOF
#include <stdio.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    for linker in $LINKERS
    do
        $compiler -o nopie pie.c  -fuse-ld=$linker
        $READELF -e nopie | { ! grep 'DYN (Shared object file)' ;}

        $compiler -o pie pie.c -pie -fPIE -fuse-ld=$linker
        $READELF -e pie | grep 'DYN (Shared object file)'

    done
done

rm pie.c nopie pie
