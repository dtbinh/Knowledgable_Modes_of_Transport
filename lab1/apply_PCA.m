% Project data on a PCA space obtained through compute_PCA
% Input:
%  - pca : pca struct from compute_PCA
%  - data : N x M matrix of N samples in the original feature space
% Output:
%  - pca_data : N x D matrix with the N samples projected
%               to the D-dimensional PCA space
%
% SEE ALSO compute_PCA, backproject_PCA

function pca_data = apply_PCA(pca, data)

% do PCA transform
% ----------------------
pca_data = (data - pca.mean)*pca.components; 
% ----------------------

% Again, our order of matrix multiplication will differ from the appendix
% since our indexing is inverted, but this is otherwise a simple operation
