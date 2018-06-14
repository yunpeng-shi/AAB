# Estimation of Camera Locations in Highly Corrupted Scenarios: All About that Base, No Shape Trouble, CVPR 2018.

This project proposed a strategy for improving camera location estimation in structure from motion. Our strategy identifies severely
corrupted pairwise directions by using a geometric consistency condition. It then selects a cleaner set of pairwise directions
as a preprocessing step for common solvers. Please see https://arxiv.org/pdf/1804.02591.pdf for details.
## What are included

### 4 matlab files:
```
UniformCorruptionModel.m
```
This function generates synthetic data using uniform corruption model of [1]. See detailed instructions in the header of the file.
```
NaiveAAB.m
```
This function computes Naive AAB statistic given a graph (adjacency matrix) and a set of pairwise directions. See detailed instructions in the header of the file.
```
IRAAB.m
```
This function computes IR-AAB statistic given a graph (adjacency matrix) and a set of pairwise directions. See detailed instructions in the header of the file.
```
demo.m
```
This file demonstrates the performance of AAB statistics given synthetic data generated from uniform corruption model. The code for drawing scatter plots and ROC curves are 
provided in the file.


## License
© Regents of the University of Minnesota. All rights reserved.


## Reference
[1] Yunpeng Shi and Gilad Lerman, Estimation of Camera Locations in Highly Corrupted Scenarios: All About that Base, No Shape Trouble, CVPR 2018.
