function [new] = LR_version_symm(TC)
% Converts an ROI matrix from a paired to a symmetric ordering along the
% vertical axis.

nROI = size(TC,1);

odd = [1:2:nROI];
even = sort([2:2:nROI],'descend');
new(1:(nROI/2),:) = TC(odd,:);
new((nROI/2)+1:nROI,:) = TC(even,:);
    
 end