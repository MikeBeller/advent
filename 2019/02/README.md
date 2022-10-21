# Performance of lua/luajit (various versions) vs python3 and pypy3

| program         |   lua5.1.5   |   lua 5.4.4   |   luajit |
|-----------------|--------------|---------------|----------|
| get/set funcs   |    26.8      |     19.2      |    1.6   |
| direct array    |    18.6      |     13.1      |    1.6   |
| rawset/rawget   |    26.8      |     22.4      |    1.6   |
| table.unpack    |    13.8      |     10.2      |    2.7   |
| metatables      |    49.0      |     43.1      |    2.5   |
|-----------------------------------------------------------|

By comparison, python 3.8 is 8.3 seconds (better than all
non-luajit lua versions), and pypy3 is 0.36 seconds, better than
the best luajit version.  What's up?

In general

* Lua 5.4 is significantly faster than Lua 5.1, but luajit crushes them
* Function calls have a significant overhead (direct arrays are faster),
  but not in luajit
* Rawset/rawget is not meaningfully faster for tables (which don't have metatables)
* table.unpack can help sometimes for non-jit lua, but hurts luajit
