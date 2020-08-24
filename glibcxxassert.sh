#!bin/sh
set -e
set -x

COMPILERS="clang++ g++"

cat > glibcxxassert.cpp <<EOF
#include <vector>
float foo(std::vector<float> const& c) {
    return c[0];
}
EOF

for compiler in $COMPILERS
do
    $compiler -S glibcxxassert.cpp -o- -D_GLIBCXX_ASSERTIONS -O2 | grep abort
    $compiler -S glibcxxassert.cpp -o- -U_GLIBCXX_ASSERTIONS -O2 | { ! grep abort ; }
done

rm glibcxxassert.cpp
