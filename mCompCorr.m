function [FDR, Bonferroni, Sidak] = mCompCorr(N, p, pval)
% MCOMPCORR implements mutliple-comparison correction with FDR, Bonferroni,
% and Dunn-Sidak thresholds.
%	

% Set default values
if isempty(N)
	N = size(p,1);
end

% Run FDR correction
FDR = zeros(N, length(pval));
for s = 1:length(pval)
	FDR(sort(FDR_benjHoch(p, pval(s))), s) = 1;
end
FDR = logical(squeeze(FDR));

% Run Bonferroni multiple comparison correction
Bonferroni = zeros(N, length(pval));
for s = 1:length(pval)
	Bonferroni(:,s) = (p < (pval(s)/N));
end
Bonferroni = logical(squeeze(Bonferroni));

% Run Dunn-Sidak multiple comparison correction
Sidak = zeros(N, length(pval));
for s = 1:length(pval)
	alpha = 1-(1-pval(s))^(1/N);
	Sidak(:,s) = (p < alpha);
end
Sidak = logical(squeeze(Sidak));

end

