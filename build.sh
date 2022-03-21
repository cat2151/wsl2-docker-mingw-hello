#!/usr/bin/env bash
set -x    # 何が実行されているかログでわかりやすくする用
SECONDS=0 # 時間計測用

createSourceFile() { # 引数 : $cName, $cppName
  cName=$1
  cppName=$2
  cat <<EOS > $cName
#include <stdio.h>
int main() { printf("hello, world C\n"); }
EOS

  cat <<EOS > $cppName
#include <iostream>
int main() { std::cout << "hello, world C++\n"; }
EOS
}

build() { # 引数 : compiler, sourceName, option
  compiler=$1
  sourceName=$2
  option=$3
  exeName=${compiler}_${sourceName}.exe
  echo "---"
  echo "$compiler"
  ls -al --color $sourceName
  $compiler -o $exeName $sourceName -ggdb $option
  ls -al --color $exeName
}

buildHelloWorld() {
  cName=hello_c.c
  cppName=hello_c++.cpp
  createSourceFile $cName $cppName

  build x86_64-w64-mingw32-gcc $cName   ""
  build x86_64-w64-mingw32-g++ $cppName ""
}

printSeconds() { # 引数 SECONDS
  ((sec=${1}%60, min=${1}/60))
  echo $(printf "かかった時間 : %02d分%02d秒" ${min} ${sec})
}

main() {
  buildHelloWorld
  printSeconds ${SECONDS}
}


###
main 2>&1 | tee build.log
