#!/usr/bin/env zsh

# this script located at $HOME/builds/llvm-build/llvm-build-x86_64-linux.sh

set -ex

sudo pacman -Syyu

cd $HOME/builds/llvm-build/llvm-project

# git reset --hard
# git clean --force -d -x
git pull origin main

cmake -S llvm -B build -G Ninja \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG -march=native -mtune=native" \
    -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG -march=native -mtune=native" \
    -DCMAKE_C_COMPILER_LAUNCHER=sccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=sccache \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DLLVM_HOST_TRIPLE="x86_64-pc-linux-gnu" \
    -DLLVM_ENABLE_LIBCXX=TRUE \
    -DCMAKE_INSTALL_PREFIX=$HOME/builds/llvm-build/llvm-build-install \
    -DLLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;lld;lldb;mlir;polly" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libc;libcxx;libcxxabi;libunwind;openmp" \
    -DLLVM_TARGETS_TO_BUILD="all" \
    -DLIBCXX_INSTALL_MODULES=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_ENABLE_Z3_SOLVER=ON \
    -DLLVM_ENABLE_ZLIB=TRUE \
    -DLLVM_POLLY_LINK_INTO_TOOLS=ON \
    -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
    -DLLVM_ENABLE_FFI=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_LLD=ON \
    -DLLVM_ENABLE_LTO=Full \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DLLVM_SOURCE_PREFIX=. \
    -DLLVM_USE_RELATIVE_PATHS_IN_FILES=ON

# -DLLVM_ENABLE_LTO=Thin \
# -DCMAKE_CXX_FLAGS="-O3 -DNDEBUG -march=native -mtune=native" \
# cat /etc/makepkg.conf | grep CHOST
# -DLLVM_HOST_TRIPLE="x86_64-pc-linux-gnu" \
# -DCLANG_CONFIG_FILE_SYSTEM_DIR=~/.config/clang \
# -DCLANG_CONFIG_FILE_USER_DIR=~/.config/clang
# -DLLVM_BUILD_LLVM_DYLIB=ON \
# -DLLVM_LINK_LLVM_DYLIB=ON \
# -DLLVM_ENABLE_LTO=Full \
# -DLLVM_USE_LINKER=lld \

ninja --verbose -C build

rm -rf $HOME/builds/llvm-build/llvm-build-install/

ninja --verbose -C build install
