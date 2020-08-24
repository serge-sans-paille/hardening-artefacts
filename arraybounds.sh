#!bin/sh
set -e
set -x

COMPILERS="clang gcc"

cat > arraybounds.c <<EOF
struct foo {
    char buffer[10];
};
char bar(struct foo* f) {
    return f[1].buffer[10];
}
EOF

for compiler in $COMPILERS
do
    ! $compiler arraybounds.c -O2 -Warray-bounds -Werror
done

rm arraybounds.c
