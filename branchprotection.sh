#!bin/sh
set -e
set -x

COMPILERS="clang"

cat > branchprotection.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    $compiler -S -o- branchprotection.c --target=aarch64-arm-none-eabi -march=armv8.5-a -mbranch-protection=standard | grep paciasp

    $compiler -S -o- branchprotection.c --target=aarch64-arm-none-eabi -march=armv8.5-a -mbranch-protection=none | { ! grep paciasp ; }
done

rm branchprotection.c
