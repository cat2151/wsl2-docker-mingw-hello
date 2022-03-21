#!/usr/bin/env bash
set -x    # �������s����Ă��邩���O�ł킩��₷������p
SECONDS=0 # ���Ԍv���p

createSourceFile() { # ���� : $cName, $cppName
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

build() { # ���� : compiler, sourceName, option
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

printSeconds() { # ���� SECONDS
  ((sec=${1}%60, min=${1}/60))
  echo $(printf "������������ : %02d��%02d�b" ${min} ${sec})
}

main() {
  buildHelloWorld
  printSeconds ${SECONDS}
}


###
main 2>&1 | tee build.log
