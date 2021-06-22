function [sig] = robustTests(A, B, N, varargin)
% ROBUSTTESTS is a wrapper function for a statistical test paired with
% multiple comparison correction.
%	

% Set default values
if isempty(N)
	N = size(A,1);
end
pval = 0.05;
testtype = 'kstest2';
permutations = 10000;
exact = false;

% unpack varagin
for k = 1:2:length(varargin)
	switch varargin{k}
		case 'p'
			pval = varargin{k+1};
		case 'testtype'
			testtype = varargin{k+1};
		case 'permutation'
			permutations = varargin{k+1};
		case 'exact'
			exact = varargin{k+1};
	end
end

% Preallocate storage arrays
sig.h = nan(N, 1);
sig.p = nan(N, 1);
sig.tstat = nan(N, 1);

% Run tests for each assembly
switch testtype
	case 'kstest2'
		for r = 1:N
			[sig.h(r), sig.p(r), sig.tstat(r)] = kstest2(A(r,:), B(r,:), 'Alpha',pval(1));
		end
		clear r
	case 'ttest2'
		for r = 1:N
			[sig.h(r), sig.p(r), ~, stats] = ttest2(A(r,:), B(r,:), 'Alpha',pval(1));
			sig.tstat(r) = stats.tstat;
		end
	case 'permutation'
		for r = 1:N
			[sig.p(r), ~, sig.tstat(r)] = permutationTest(A(r,:), B(r,:), permutations, 'exact',exact, 'sidedness','both');
			sig.h(r) = sig.p(r) < pval(1);
		end
	case 'ranksum'
		for r = 1:N
			[sig.h(r), sig.p(r), stats] = ranksum(A(r,:), B(r,:), 'Alpha',pval(1));
			sig.tstat(r) = stats.ranksum;
		end
	otherwise
		
end

% Run mutliple comparison corrections on p-values
[sig.FDR, sig.Bonferroni, sig.Sidak] = mCompCorr(N, sig.p, pval);

end