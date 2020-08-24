#!bin/sh
set -e
set -x

COMPILERS="gcc clang"

cat > stackclash.c <<EOF
#include <stdio.h>
#include <string.h>
int main() {
    volatile char data[10000];
    return data[0] + data[9999];
}
EOF

for compiler in $COMPILERS
do
    $compiler stackclash.c -o- -fstack-clash-protection -S | grep '4096, %rsp'
done

rm stackclash.c
