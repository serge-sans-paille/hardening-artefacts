#!bin/sh
set -e
set -x

COMPILERS="gcc clang"

cat > cfprotection.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    $compiler -S -o- cfprotection.c -fcf-protection=full | grep endbr64

    $compiler -S -o- cfprotection.c -fcf-protection=none | { ! grep endbr64 ;}
done

rm cfprotection.c
