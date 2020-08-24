#!bin/sh
set -e
set -x

COMPILERS="clang gcc"

cat > fortify.c <<EOF
#include <stdio.h>
#include <string.h>
int main(int argc, char** argv) {
    char buffer[10];
    strcpy(buffer, argv[1]);
    puts(buffer);
    return 0;
}
EOF

for compiler in $COMPILERS
do
    ! $compiler fortify.c -ofortify  -D_FORTIFY_SOURCE=2 -O1
    nm fortify | grep __strcpy_chk
done

rm fortify.c fortify
