#!bin/sh
set -e
set -x

COMPILERS="clang gcc"

cat > printf.c <<EOF
#include <stdio.h>
int main(int argc, char** argv) {
    printf(argv[1]);
    return 0;
}
EOF

for compiler in $COMPILERS
do
    #NB: -Wformat is only needed by gcc
    ! $compiler printf.c -oprintf -Wformat -Wformat-security -Werror

done

rm printf.c
