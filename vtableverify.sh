#!bin/sh
set -e
set -x

COMPILERS="g++"

cat > vtableverify.cpp <<EOF
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
    $compiler vtableverify.cpp -ovtableverify -fvtable-verify=preinit -O1
    nm vtableverify | grep __VLTVerifyVtablePointer
done

rm vtableverify vtableverify.cpp
