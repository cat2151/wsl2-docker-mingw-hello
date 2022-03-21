@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

# Docker Hubから docker-mingw-w64 を得てrunし、hello worldをコンパイルしてWindows用exeを作り、それらのログを出力します

# スクリプトの動作ディレクトリを得る
function getScriptDir() {
  if ("$PSScriptRoot" -eq "") {
    $Pwd.Path # bat化した場合、$PSScriptRoot や $MyInvocation.MyCommand.Path や $PSCommandPath は空なので、bat起動時のカレントディレクトリで代用する
  } else {
    $PSScriptRoot
  }
}

# ログを記録開始する（処理時間計測を含む）
function startLog($filename) {
  $null = Start-Transcript $filename
  Get-Date # 呼び出し元で時間計測スタート時刻を記録する用
}

# ログを記録終了する
function endLog() {
  "かかった時間 : " + ((Get-Date) - $startTime).ToString("m'分's'秒'")
  Stop-Transcript
}

# "helloビルド用sh" の実体をダウンロードする
function download_build_hello_exe_sh() {
  curl.exe -L $url_build_hello_exe_sh --output ${helloDir}\build.sh
}

# hello exeをビルドする
function buildHello() {
  docker run --rm -ti -v "$($pwd.Path):/mnt" mmozeiko/mingw-w64 ./build.sh # docker-mingw-w64公式コマンドのpwd部分を、bash用からpowershell用に書き換えたもの
}

# hello exeを動作確認する
function testHello() {
  .\x86_64-w64-mingw32-gcc_hello_c.c.exe
  .\x86_64-w64-mingw32-g++_hello_c++.cpp.exe
}

function main() {
  pushd ${helloDir}
    download_build_hello_exe_sh # build.shを変更してビルドする場合はここをコメントアウトする
    buildHello
    testHello
  popd
}


###
$url_build_hello_exe_sh = "https://raw.githubusercontent.com/cat2151/wsl2-docker-mingw-hello/main/build_hello_exe.sh"
$scriptDir = getScriptDir
$helloDir = "${scriptDir}\WSL2_docker_mingw_hello" # batのあるディレクトリをできるだけ汚さない用
$startTime = startLog "${helloDir}\WSL2_docker_mingw_hello.log"
main
endLog
