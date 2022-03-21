@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

# Docker Hub���� docker-mingw-w64 �𓾂�run���Ahello world���R���p�C������Windows�pexe�����A�����̃��O���o�͂��܂�

# �X�N���v�g�̓���f�B���N�g���𓾂�
function getScriptDir() {
  if ("$PSScriptRoot" -eq "") {
    $Pwd.Path # bat�������ꍇ�A$PSScriptRoot �� $MyInvocation.MyCommand.Path �� $PSCommandPath �͋�Ȃ̂ŁAbat�N�����̃J�����g�f�B���N�g���ő�p����
  } else {
    $PSScriptRoot
  }
}

# ���O���L�^�J�n����i�������Ԍv�����܂ށj
function startLog($filename) {
  $null = Start-Transcript $filename
  Get-Date # �Ăяo�����Ŏ��Ԍv���X�^�[�g�������L�^����p
}

# ���O���L�^�I������
function endLog() {
  "������������ : " + ((Get-Date) - $startTime).ToString("m'��'s'�b'")
  Stop-Transcript
}

# "hello�r���h�psh" �̎��̂��_�E�����[�h����
function download_build_hello_exe_sh() {
  curl.exe -L $url_build_hello_exe_sh --output ${helloDir}\build.sh
}

# hello exe���r���h����
function buildHello() {
  docker run --rm -ti -v "$($pwd.Path):/mnt" mmozeiko/mingw-w64 ./build.sh # docker-mingw-w64�����R�}���h��pwd�������Abash�p����powershell�p�ɏ�������������
}

# hello exe�𓮍�m�F����
function testHello() {
  .\x86_64-w64-mingw32-gcc_hello_c.c.exe
  .\x86_64-w64-mingw32-g++_hello_c++.cpp.exe
}

function main() {
  pushd ${helloDir}
    download_build_hello_exe_sh # build.sh��ύX���ăr���h����ꍇ�͂������R�����g�A�E�g����
    buildHello
    testHello
  popd
}


###
$url_build_hello_exe_sh = "https://raw.githubusercontent.com/cat2151/wsl2-docker-mingw-hello/main/build_hello_exe.sh"
$scriptDir = getScriptDir
$helloDir = "${scriptDir}\WSL2_docker_mingw_hello" # bat�̂���f�B���N�g�����ł��邾�������Ȃ��p
$startTime = startLog "${helloDir}\WSL2_docker_mingw_hello.log"
main
endLog
