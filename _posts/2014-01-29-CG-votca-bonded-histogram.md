---
layout: post
tags: [CG,votca,histogram]
category: CG
---

## Calculating bonded histograms using Votca

Votca generates bonded histograms by

1. counting the number of items in each bin (number of steps*number of arrays)
1. scales according to bond (1/$r^2$) or angle (1/sin($\phi$))
1. normalizes to make the area equal to 1.

*check*:

- tools/src/libtools/histogram.cc for generating histograms

Does gromacs scale the bonded histograms?
