#!bin/sh
set -e
set -x

LINKERS="ld lld"
CC=clang
READELF=readelf

cat > execstack.c <<EOF
#include <stdio.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for linker in $LINKERS
do
    $CC -o noexecstack execstack.c -Wl,-z,noexecstack -fuse-ld=$linker
    $READELF -e noexecstack | { ! grep -E 'GNU_STACK.*RWE' ; }

    $CC -o execstack execstack.c -Wl,-z,execstack -fuse-ld=$linker
    $READELF -e execstack | grep -E 'GNU_STACK.*RWE'

done

rm execstack.c execstack noexecstack
