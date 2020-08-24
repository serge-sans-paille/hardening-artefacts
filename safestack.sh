#!bin/sh
set -e
set -x

# not in gcc, see https://gcc.gnu.org/legacy-ml/gcc/2016-04/msg00083.html
COMPILERS="clang"

cat > safestack.c <<EOF
#include <stdio.h>
#include <string.h>
int main() {
    puts("hello");
    return 0;
}
EOF

for compiler in $COMPILERS
do
    $compiler safestack.c -osafestack -fsanitize=safe-stack
    nm safestack | grep __get_unsafe_stack_ptr
done

rm safestack safestack.c
