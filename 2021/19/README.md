# Performance

lua 5.1 -- 7.0s
lua 5.4 -- 5.6s
python3.9 -- 4.5s
pypy3.9 -- 3.1s
luajit -- 1.3s



## Lua installations

5.1 in $HOME/local
```sh
wget
untar
make INSTALL_TOP=$HOME/local posix install
```

5.4.4 in it's own directory

```
make INSTALL_TOP=`pwd` posix
make INSTALL_TOP=`pwd` install
```

## luajit

```sh
git clone https://luajit.org/git/luajit.git
make PREFIX=$HOME/local install
```

## luarocks -- doesn't work yet!!!!

need to tweak to add --with-lua-dir  or some such

```sh
wget https://luarocks.org/releases/luarocks-3.9.1.tar.gz
tar zxpf luarocks-3.9.1.tar.gz
cd luarocks-3.9.1
./configure PREFIX=$HOME/local && make install
```
