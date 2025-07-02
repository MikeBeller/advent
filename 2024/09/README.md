# Performance

```
mike@MikeBook-Pro 09 % time python 202409.py
6359213660505
6381624803796
python 202409.py  28.39s user 0.15s system 99% cpu 28.543 total
mike@MikeBook-Pro 09 % time lua5.4 202409.lua
6359213660505.0
6381624803796.0
lua5.4 202409.lua  28.85s user 1.25s system 98% cpu 30.427 total
mike@MikeBook-Pro 09 % time luajit 202409.lua
6359213660505
6381624803796
luajit 202409.lua  10.72s user 0.08s system 99% cpu 10.844 total
```

