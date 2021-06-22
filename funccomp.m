function [C] = funccomp(X, m)
% FUNCCOMP computes the functional complexity (Zamora-Lopez et. al. 2016)
% of the input vector X.  Based on the the principle that a complex signal
% must have substantial variance, the functional complexity is defined as
% the difference between the signal's empirical distribution and the
% uniform distribution.
%	
%	INPUTS
%		X: the input vector (data).
%		m: the number of bins for the histogram.  Optional; may be replaced
%		with [].
%	OUTPUTS
%		C: the extimated functional complexity of X.

if isempty(m)
	[N, edges] = histcounts(X, 'Normalization','probability');
	m = length(edges)-1;
	C = 2*(m-1) / m;
	C = 1 - C*sum(abs(N-(1/m)));
else
	N = histcounts(X, m, 'Normalization','probability');
	C = 2*(m-1) / m;
	C = 1 - C*sum(abs(N-(1/m)));
end

end

