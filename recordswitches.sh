#!bin/sh
set -e
set -x

# not supported in clang
COMPILERS="gcc clang"
READELF=readelf

cat > recordswitches.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    int v;
    return v;
}
EOF

for compiler in $COMPILERS
do
    $compiler recordswitches.c -O2 -frecord-gcc-switches -o recordswitches
    $READELF recordswitches -p .GCC.command.line | grep O2
done

rm recordswitches recordswitches.c
