Advent of Code
==============

I've been working Advent of Code problems for a few years 
as a relaxing passtime, and as a vehicle to learn new programming languages. 
I don't try to do them quickly or keep up with the 
incredibly fast competitive programmers on the leaderboard so no spoilers here! 
(Anyway I'm generally not awake at midnight US Eastern time, when they are posted. :-) )
In other words -- as Eric Wastl requests in the AoC FAQ -- no solutions will be posted
here before the leaderboard of AoC is long past full. 

Solutions are in whatever language I was interested
in at the time I wrote the solution -- and often in several so I could benchmark
the performance of different languages, or the expressiveness of different languages. 

most commonly, my solutions are in:
python, julia, elixir, lua, janet (a lisp dialect )
Some handful are in C, gforth, rust, some in Go, maybe a few in JavaScript or Typescript.

Many thanks to Eric Wastl who runs AoC for this wonderful project. 

## Notes for setting up an environment to run these:

All solutions were implemented on Linux.  Usually a recent Ubuntu LTS distro.
You can probably run any or all of them for free on the default "github codespace",
(which has python and C and nodejs by default), 
though you may need to do a bit of installation for other languages.
Here are a few:

```sh
sudo apt update
```

# for lua

```sh
sudo apt install lua5.1 luajit luarocks rlwrap 
sudo luarocks install penlight
```

# for elixir

```sh
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install elixir
```

# for prolog:

```
wget https://github.com/mthom/scryer-prolog/releases/download/v0.9.3/scryer-prolog_ubuntu-20.04.zip
unzip unzip scryer-prolog_ubuntu-20.04.zip
sudo cp scryer-prolog_ubuntu-20.04_x86_64-unknown-linux-gnu/scryer-prolog /usr/local/bin
sudo chmod +x /usr/local/bin/scryer-prolog
```

And put the following in your .scryerrc in your home directory:

```
:- use_module(library(lists)).
:- use_module(library(clpz)).
:- use_module(library(pio)).
:- use_module(library(dcgs)).
```
