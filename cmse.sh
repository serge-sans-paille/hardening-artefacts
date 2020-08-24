
#!bin/sh
set -e
set -x

COMPILERS="clang"

cat > cmse.c <<EOF
#include <arm_cmse.h>
int __attribute__((cmse_nonsecure_call)) (*foo)(int);
int bar(int a) {
   return foo(a) + 1;
}
EOF

for compiler in $COMPILERS
do
    $compiler cmse.c -S -o- -mfloat-abi=soft -target armv8m.base-none-linux-gnu -O2 -mcmse | grep blxns
    $compiler cmse.c -S -o- -mfloat-abi=soft -target armv8m.base-none-linux-gnu -O2 | { ! grep blxns ; }
done

rm cmse.c
