%% Author: Yunpeng Shi
%% © Regents of the University of Minnesota. All rights reserved.
%% Generate synthetic data using Uniform Corruption Model of the paper [1].

%% Input Parameters: 
%% n: the number of cameras
%% p: the probability of connecting a pair of vertices. G(V,E) is Erdos-Renyi graph G(n,p).
%% q: the probability of corrupting an edge
%% sigma: the noise level (>0)
%% dist (optional): the distribution ('uniform' or 'gaussian') of noise. By default the distribution is uniform on sphere S^2.

%% Output:
%% UCModel.AdjMat: n by n adjacency matrix
%% UCModel.GammaMat: 3 by edge_num matrix of pairwise directions. Each column is a pairwise direction. edge_num is the number of edges.
%% UCModel.GammaMat_gt: 3 by edge_num matrix of the ground truth pairwise directions.
%% UCModel.TMat_gt: 3 by n matrix of the ground truth locations. The i-th column is the 3D coordinate of the i-th location. 
%% UCModel.true_error: 3 by edge_num matrix of error of pairwise directions. For edge ij, the error is the angle between...
%% gamma_ij and the ground truth.

%% Reference
%% [1] Yunpeng Shi and Gilad Lerman. "Estimation of Camera Locations in Highly Corrupted Scenarios: ...
%% All About that Base, No Shape Trouble." CVPR 2018.


function UCModel = UniformCorruptionModel(n, p, q, sigma, dist)

if ~exist('dist','var')
    dist = 'uniform';
end
G = rand(n,n) < p;
G = tril(G,-1);
% generate adjacency matrix
AdjMat = G + G'; 
[Ind_j, Ind_i] = find(G==1);
edge_num = length(Ind_i);
% generate 3D gaussian locations
TMat_gt = randn(3,n);
% compute ti-tj
GammaMat_gt = TMat_gt(:,Ind_i)-TMat_gt(:,Ind_j);
% normalize to get the ground truth pairwise directions
gamma_norm = sqrt(sum(GammaMat_gt.^2,1));
GammaMat_gt = bsxfun(@rdivide,GammaMat_gt,gamma_norm);
%add noise and corruption~U(S^2)
GammaMat = GammaMat_gt;
noiseInd = rand(1,edge_num)>=q;
% indices of corrupted edges
corrInd = logical(1-noiseInd);
% gaussian corruption/noise
corr_noise = randn(3,edge_num);
corr_noise_norm = sqrt(sum(corr_noise.^2,1));
if strcmp(dist, 'uniform')
    % normalize gaussian r.v. so that it follows U(S^2)
    corr_noise = bsxfun(@rdivide,corr_noise,corr_noise_norm);
end
% noise ~N(0,I) or U(S^2)
GammaMat(:, noiseInd) = GammaMat_gt(:, noiseInd)+sigma*corr_noise(:, noiseInd);
GammaMat(:, corrInd) = corr_noise(:, corrInd);
gamma_norm = sqrt(sum(GammaMat.^2,1));
% normalize pairwise directions so that corruption ~U(S^2)
GammaMat = bsxfun(@rdivide,GammaMat,gamma_norm);
% compute the error of each pairwise direction
true_error = abs(acos(sum(GammaMat_gt.*GammaMat,1)));
UCModel.AdjMat = AdjMat;
UCModel.TMat_gt = TMat_gt;
UCModel.GammaMat_gt = GammaMat_gt;
UCModel.GammaMat = GammaMat;
UCModel.true_error = true_error;
end
