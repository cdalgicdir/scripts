---
layout: post
tags: [papers, g_wham, umbrella sampling, WHAM]
category: papers
---

### g_wham: A Free Weighted Histogram Analysis Implementation Including Robust Error and Autocorrelation Estimates

#### Jochen S. Hub, Bert L. de Groot, and David van der Spoel

> the idea of WHAM is to estimate the statistical uncertainty of the unbiased
> probability distribution given the umbrella histograms, and subsequently to
> compute the PMF that corresponds to the smallest uncertainty.

#### Three methods to calculate uncertainties in the PMF:

1. "bootstrapping of hypothetical trajectories based on the umbrella histograms together with the respective autocorrelation time"
	- each window is run once and the corresponding trajectory is bootstrapped (new trajectories are generated)
	- provides an accurate error estimate if (and only if) the histograms are sufficiently converged.
1. "by bootstrapping complete histograms"
	- where an umbrella window is simulated multiple times each with different initial configurations. Then the histograms are pooled and a group of "complete histograms" is generated. Each histogram (including the multiple runs for each window) is treated as an "individual observation" and a new set of Nw histograms are selected out of this "complete histograms" group, where multiple selections are allowed. Compared to method 1, no new trajectories or histograms are generated in this method, instead the already available histograms are bootstrapped.
	- better for limited sampling
	- the probability of choosing one histogram out of n histograms is 1/n. (n=Nw*sum(m$_i$) where m$_i$ is the number of multiple runs for ith window)
one should be careful that the bootstrapped histograms should overlap. To this end, the histograms can be grouped along the reaction coordinate and each group can be separately bootstrapped to avoid hollow regions in the reaction coordinate.
1. "by using the Bayesian bootstrap of complete histograms, that is, by assigning random weights to the histograms."
	- just like method 2, but instead assigns random weights to all histograms within each bootstrap to avoid non-overlapping of histograms. So the probability of choosing a histogram becomes w$_i$ instead of 1/n.
	- "the continuous weights w$_i$ are almost never exactly zero" so that a gap along the reaction coordinate using the set of bootstrapped histograms is avoided.

- If the histograms are affected by long autocorrelations, as frequently occurrs in simulations of large biomolecules, methods 2. and 3. provide a more accurate error estimate."
- "In nonhomogeneous systems such as a protein channel or a lipid membrane surrounded by bulk water, the autocorrelation times may substantially vary along the reaction coordinate and thus not cancel from the WHAM equations."

### NOTES:

- If the molecules have slow motions so that the simulation cannot sample all the configurations, then the suggestion is to sample the same window multiple times using different initial configurations.

![Obtaining unbiased probability distribution through WHAM]({{ site.baseurl }}/images/papers-images/hub2010-wham.png)


