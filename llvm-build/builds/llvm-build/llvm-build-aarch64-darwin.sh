#!/usr/bin/env zsh

# this script located at $HOME/builds/llvm-build/llvm-build-aarch64-darwin.sh

set -ex

brew install llvm --only-dependencies --build-from-source

cd $HOME/builds/llvm-build/llvm-project

git reset --hard
git clean --force -d -x

# git pull origin main
git pull tsinghua main
# git pull bfsu main
# git pull sjtu main

cmake -S llvm -B build -G Ninja \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=sccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=sccache \
    -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG -march=native -mtune=native" \
    -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG -march=native -mtune=native" \
    -DCMAKE_INSTALL_PREFIX=$HOME/builds/llvm-build/llvm-build-install \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb;mlir" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libc;libcxx;libcxxabi;libunwind;openmp" \
    -DLLVM_TARGETS_TO_BUILD="all" \
    -DLIBCXX_INSTALL_MODULES=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_ENABLE_Z3_SOLVER=ON \
    -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
    -DLLVM_ENABLE_FFI=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DLLVM_SOURCE_PREFIX=. \
    -DLLVM_USE_RELATIVE_PATHS_IN_FILES=ON \
    -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
    -DCLANG_CONFIG_FILE_SYSTEM_DIR=~/.config/clang \
    -DCLANG_CONFIG_FILE_USER_DIR=~/.config/clang

# -DLLVM_ENABLE_LTO=Thin \
# -DLLVM_ENABLE_LTO=Full \
# -DLLVM_ENABLE_LLD=ON \
#
# -DCMAKE_C_COMPILER=/opt/homebrew/opt/llvm/bin/clang \
# -DCMAKE_CXX_COMPILER=/opt/homebrew/opt/llvm/bin/clang++ \
# -DCMAKE_LINKER=/opt/homebrew/opt/lld/bin/lld \
# -DCMAKE_AR=/opt/homebrew/opt/llvm/bin/llvm-ar \
# -DCMAKE_NM=/opt/homebrew/opt/llvm/bin/llvm-nm \
# -DCMAKE_RANLIB=/opt/homebrew/opt/llvm/bin/llvm-ranlib \
# -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} -D_DARWIN_C_SOURCE" \
# -DCMAKE_CXX_FLAGS=" ${CMAKE_CXX_FLAGS} -D_DARWIN_C_SOURCE" \
#
# -DLLDB_ENABLE_LZMA=ON \
# -DLLVM_POLLY_LINK_INTO_TOOLS=ON \
# -DLLVM_ENABLE_LLVM_LIBC=ON \

ninja --verbose -C build

rm -rf $HOME/builds/llvm-build/llvm-build-install/

ninja --verbose -C build install

