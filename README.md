# WSL2 docker mingw hello

WSL2 + docker-mingw-w64 を使い、hello worldのexeを `環境を汚さず` `自動で` ビルドします。

# Features
- 以下を自動化します :
  - docker-mingw-w64 を Docker Hubから得る
    - これはgcc系のC/C++ソースからWindows用exeをビルドできる仕組みです
  - docker-mingw-w64 用の build.sh を得る
    - ユーザーが任意に作れる build.sh の参考用に、hello worldを提供します
  - hello worldをクロスコンパイルする
    - これはWindowsで動作するexeです
      - Dockerで動くUbuntu上でmingwによりクロスコンパイルされて出力されます
  - hello worldをWindows上で実行し、結果を得る
  - 上記すべてのログを出力する

- 環境を汚さないため、手軽に扱えます。
- コマンドプロンプトからこのコマンドを実行するだけで自動ですべてが完了します。面倒な操作は不要です。
```
curl.exe -L https://raw.githubusercontent.com/cat2151/wsl2-docker-mingw-hello/main/WSL2_docker_mingw_hello.bat --output WSL2_docker_mingw_hello.bat && WSL2_docker_mingw_hello.bat
```

# Requirement
- Windows + WSL2 + Docker
- Windows上でDockerが動作すること
- DockerがLinuxコンテナを起動できること（多くの場合はそうです）
- 1.7GB程度の空き容量
- 5分～15分程度の時間（ネットワーク速度により変わります）
- batを実行する場所のフルパス名に半角スペースや日本語を含まないこと

# Usage
- 前述のコマンドを実行します。
- ディレクトリ `WSL2_docker_mingw_hello` 配下を確認します。
  - ログや、hello world exe実行結果から、WSL2 + Ubuntuでexeがビルドできたことを確認します。
- 適宜、batとbuild.shを書き換えて、任意のexeをビルドして使うこともできます。また、それを繰り返して使う場合は、書き換えたbatとshをgit等で管理して自動化すると楽かもしれません。

# なぜ名前の構造がmsys2-auto-installと違うの？
- （同じ構造だとwsl2-auto-installやdocker-auto-installになりそうですが、そうではなくwsl2-docker-mingw-helloという名前にしました。）
- MSYS2/Cygwinと違い、WSL2/Dockerは一つのOSに一つしかinstallできないためです。（そしてこれを使う方は既にinstall済みです）
  - MSYS2/Cygwinのときは、auto-installで生成したMSYS2/Cygwinディレクトリ配下を「使い捨ての一つの環境」にできました。
  - かわりに今回「使い捨ての一つの環境」にするのは、「Docker Hubからpullしたimage "docker-mingw-w64" をDockerでLinuxコンテナとして起動した、名無しの環境」です。
  - 今回の「使い捨ての一つの環境」はinstallされません。
    - hello world exeをビルドしたら、それを「DockerにmountしたWindowsディレクトリ上」に出力したのち、Linuxコンテナは消滅します（使い捨てされます）ので、ホストOSの環境を汚しません。
- Docker Hubのimageをrunする方式か、そうでないか、を区別がつくようにするためです。
- mingwでクロスコンパイルするか、そうでないか、を区別がつくようにするためです。
- hello worldをビルドするか、そうでないか、を区別がつくようにするためです。
