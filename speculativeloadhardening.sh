#!bin/sh
set -e
set -x

COMPILERS="clang"

cat > speculativeloadhardening.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    if(argc)
        puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    $compiler -S -o- speculativeloadhardening.c -mspeculative-load-hardening | grep cmov
    $compiler -S -o- speculativeloadhardening.c | { ! grep cmov ; }

done

rm speculativeloadhardening.c
