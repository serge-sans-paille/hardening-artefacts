#!bin/sh
set -e
set -x

COMPILERS="clang gcc"

cat > stackprotector.c <<EOF
#include <stdio.h>
#include <string.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    $compiler stackprotector.c -ostackprotector -fstack-protector-all
    nm stackprotector | grep __stack_chk_fail
done

rm stackprotector stackprotector.c
