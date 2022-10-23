# Performance of lua/luajit (various versions) vs python3 and pypy3

| program         |   lua5.1.5   |   lua 5.4.4   |   luajit |
|-----------------|--------------|---------------|----------|
| direct array    |     9.0      |     6.4       |    1.6   |
| python3.8       |              |     8.3       |    0.3   |
| with jit & ffi  |     -        |      -        |    0.5   |
| metatables      |    49.0      |     39.0      |    2.5   |
|-----------------------------------------------------------|

Pypy is fastest.  Luajit is competitive though, and uses a fraction
of the memory and is 500k in size vs 80MB (!)

In general

* Lua 5.4 is significantly faster than Lua 5.1, but luajit crushes them both

Other things I noticed when "tooling around"

* Function calls have a significant overhead (direct arrays are faster),
  but not in luajit
* Rawset/rawget is not meaningfully faster for tables (which don't have metatables)
* table.unpack can help to grab consecutive values sometimes for non-jit
  lua, but hurts w/ luajit

**metatables are slow**

**Directly using integer FFI arrays in luajit is super fast!!**

**integer for loops are significantly faster than ipairs!**
