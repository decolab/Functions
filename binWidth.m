function [sz] = binWidth(data, dim)
% binWidth finds an appropriate width for multi-dataset histogram bins
%   

binwidth = nan(size(data,dim),1);
f = figure; hold on;
for c = 1:size(data,dim)
    hg = histogram(data(:,c), 'Normalization','probability');
    binwidth(c) = hg.BinWidth;
end
sz = min(binwidth);
close(f);

end

