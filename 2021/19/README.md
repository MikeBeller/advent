# Performance

lua 5.1 -- 7.0s
lua 5.4 -- 5.6s
python3.9 -- 4.5s
pypy3.9 -- 3.1s
luajit -- 1.3s

## Lua installations

5.1 in $HOME/local

```sh
wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
tar xvzf lua-5.1.5.tar.gz
cd lua-5.1.5
#edit Makefile to set INSTALL_TOP to /home/mike/local
#edit config.h to set LUA_DIR to /home/mike/local instead of /usr/local
make INSTALL_TOP=$HOME/local posix install
```

5.4.4 in it's own directory

```
make INSTALL_TOP=`pwd` posix
make INSTALL_TOP=`pwd` install
```

## luajit

```sh
cd $HOME/local
git clone https://luajit.org/git/luajit.git
make PREFIX=$HOME/local install
```

## luarocks -- doesn't work yet

need to tweak to add --with-lua-dir  or some such

```sh
wget https://luarocks.org/releases/luarocks-3.9.1.tar.gz
tar zxpf luarocks-3.9.1.tar.gz
cd luarocks-3.9.1
./configure --prefix=$HOME/local  --versioned-rocks-dir --lua-version=5.1 --with-lua-lib=$HOME/local/share/lua
make
make install
luarocks install inspect
```
