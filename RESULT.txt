[ActiveRecord]
Allocated: 1631.77 KB
Retained: 1585.44 KB
Objects: 16429

[Hash]
Allocated: 343.35 KB
Retained: 203.52 KB
Objects: 5057

======================================================================
Summary
======================================================================
ActiveRecord retained: 1585.44 KB
Hash retained: 203.52 KB
Ratio (AR / Plain): 7.79x
Difference: +679.0% more memory with ActiveRecord

======================================================================
Performance Benchmark (iterations per second)
======================================================================
ruby 4.0.0 (2025-12-25 revision 553f1675f3) +PRISM [arm64-darwin25]
Warming up --------------------------------------
ActiveRecord 65.000 i/100ms
Hash (pluck) 182.000 i/100ms
Calculating -------------------------------------
ActiveRecord 650.106 (± 1.5%) i/s (1.54 ms/i) - 1.950k in 3.000221s
Hash (pluck) 1.809k (± 0.6%) i/s (552.80 μs/i) - 5.460k in 3.018402s

Comparison:
Hash (pluck): 1809.0 i/s
ActiveRecord: 650.1 i/s - 2.78x slower
