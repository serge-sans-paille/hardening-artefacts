#!bin/sh
set -e
set -x

# not supported in gcc
COMPILERS="clang"

cat > autovarinit.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    int v;
    return v;
}
EOF

for compiler in $COMPILERS
do
    $compiler autovarinit.c -S -o- -ftrivial-auto-var-init=pattern | grep 'movl' | grep '$0'

done

rm autovarinit.c
