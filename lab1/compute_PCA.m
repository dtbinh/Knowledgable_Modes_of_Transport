% Compute a D-dimensional PCA space from N samples
%
% pca = compute_PCA(data)
% pca = compute_PCA(data, D)
%
% Input:
% - data : an N x M matrix containing N samples in an M dimensional feature space
% - D: the number of PCA components to retain (optional)
%
% Output: 
% - pca  : struct with the following fields
%   - components : MxD matrix containing the M-d basis vectors of the D PCA
%            dimensions.
%   - mean       : 1xM mean feature vector of the input data
%   - variance   : 1xD vector
%                d-th entry is a number between 0 and 1 that tells the 
%                fraction of variance maintained in the d-th PCA dimension 
%
% SEE ALSO apply_PCA, backproject_PCA

function pca_model = compute_PCA(data, D)

[N, M] = size(data);

% Define default argument (use 'HELP NARGIN' if you do not understand this)
% By default, retain all dimensions in the provided data
if nargin < 2; D = M; end

pca_model = struct;
pca_model.components = [];
pca_model.mean = [];
pca_model.variance = [];

% ----------------------
%  YOUR CODE GOES HERE! 
% ----------------------

% First we calculate the mean, Matlab has a function for this which returns
% the mean of each column (which for us is each feature)
pca_model.mean = mean(data);

% Second we obtain our zero-centered data matrix X_line and use it to compute our
% covariance matrix C. Note that to compute the latter, we have to do it
% differently than in the Appendix, since our N and M are inverted
X_line = data - pca_model.mean;
C = X_line'*X_line;

% Now we do some eigen stuff, which we then have to sort according to the
% largest eigenvalue. Sorting procedure adapted from 
% https://se.mathworks.com/help/matlab/ref/eig.html#mw_8834a153-1131-4b0b-99a7-3bf3918e6cf6
[W,L] = eig(C);                     % W eigenvector matrix, L for big lambda
[d,ind] = sort(diag(L),'descend');  % d will be a col vector of the sorted eigenvalues, 
                                    % ind will contain sorting indices
L_s = L(ind,ind);
W_s = W(:,ind);

% Finally we adapt these into our return values, reducing the
% dimensionality to our desired D, and calculating fraction of variance
% contained in each component
pca_model.components = W_s(:,1:D);
pca_model.variance = reshape(d(1:D),1,[]) / sum(d(1:D));

% check that everything is OK
assert(all(size(pca_model.components) == [M, D]));
assert(all(size(pca_model.mean) == [1, M]));
assert(all(size(pca_model.variance) == [1, D]));




