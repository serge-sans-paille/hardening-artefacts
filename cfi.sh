#!bin/sh
set -e
set -x

COMPILERS="clang++"

cat > cfi.cpp <<EOF
struct foo {
    virtual int run() { return 0; }
};
struct bar : foo {
    virtual int run() { return 1; }
};

__attribute__((noinline)) int doit(foo* f);
int doit(foo* f) { return f->run(); }
int main(int argc, char** argv) {
    bar b;
    return doit(&b);
}
EOF

for compiler in $COMPILERS
do
    $compiler cfi.cpp -ocfi -flto -fsanitize=cfi -fuse-ld=lld -fvisibility=hidden
    objdump -S cfi | grep ud2
    $compiler cfi.cpp -ocfi -flto -fuse-ld=lld -fvisibility=hidden
    objdump -S cfi | { ! grep ud2 ; }
done

rm cfi cfi.cpp
