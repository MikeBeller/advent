# Optimizing Advent Code using Multiprocessing and NUMBA

Base algorithm takes **113 seconds**.  With multiprocessing.pool
and just a tiny tweak (to add a partial function to carry
the global matrix to each process) I can get a near **4x speedup**
to 30 or so seconds.

Adding numba jit to the base algo brings 113 seconds to **59 seconds**.
And then adding mp.pool brings the total time down to **16 seconds**!
