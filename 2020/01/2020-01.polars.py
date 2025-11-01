import polars as pl
c = pl.col
inp = (pl.read_csv("input.txt",has_header=False)
       .rename({'column_1': "i"}))
print(inp.join(inp,how='cross',suffix='2')
  .filter(c('i')+c('i2') == 2020).head(1)
  .with_columns(p1=c('i')*c('i2'))
      .select('p1').item())
print(inp.join(inp,how='cross',suffix='2')
      .join(inp,how='cross',suffix='3')
      .filter(c('i')+c('i2')+c('i3') == 2020)
      .head(1).with_columns(p2=c('i')*c('i2')*c('i3'))
      .select('p2').item())

