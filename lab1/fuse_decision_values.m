% Fuse decision values from two classifiers, using MEAN and MAX methods
%
% Input:
%  - dval1 : N decision values from classifier 1
%  - dval2 : N decision values from classifier 2
%
% Output:
%  - dval_fuse_mean : N averaged decision values
%  - dval_fuse_max  : N decision values, picking the descision value of the
%                     classifier with the largest ABSOLUTE (!) value.
%
function [dval_fuse_mean, dval_fuse_max] = fuse_decision_values(dval1, dval2)


% ----------------------
dval_fuse_mean=[dval1 dval2];
dval_fuse_mean=mean(dval_fuse_mean,2);
dval_fuse_max1=[dval1 dval2];
dval_fuse_max=zeros(length(dval_fuse_max1),1);
[~,ii]=max(abs(dval_fuse_max1),[],2);
for i=1:length(dval_fuse_max1)
dval_fuse_max(i,1) = dval_fuse_max1(i,ii(i));
end
% ----------------------


end