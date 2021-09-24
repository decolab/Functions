function [FCD] = computeFCD(dFC, metric)
% computeFCD is a function for computing the functional connectivity
% dynamics (FCD) matrix from a three-dimensional input array dFC.  The FCD
% matrix is a quick and efficient method for determining time epochs of
% high synchronization (integration) and low synchronization (segregation)
% across brain regions.
% INPUTS:
%	dFC: an array of dFC matrices in the format (space, space, time).  This
%		array can be either three-dimensional (in the case of dFC) or
%		two-dimensional (in the case of a leading eigenvector
%		decomposition, e.g. LEiDA or LEICA).  In either case, the final
%		dimension is assumed to be time, and the first dimension(s) assumed
%		to be spatial.  dFC matrices are assumed to be spatially symmetric.
%	metric: the metric used to measure the strength of relations between
%		time points.  Pearson correlation by default.
%
% OUTPUTS:
%	FCD: a two-dimensional matrix with dimensions (time, time).  Each
%		element (t1, t2) of the FCD displays the similarity between dFC(t1)
%		and dFC(t2), i.e. the dFC matrices at t1 and t2.  Since the dFC is
%		assumed to be symmetric, only the upper triangles of each dFC is
%		used.


% Set default correlation measure
if isempty(metric)
	metric = 'Pearson';
end

% If dFC, vectorize matrices
if ndims(dFC) == 3
	% Set parameters
	Isubdiag = find(tril(ones(size(dFC,1)), -1));
	vFC = length(Isubdiag, size(dFC,3));

	% Remove lower triangles from spatial matrices & vectorize
	for t = 1:size(dFC,3)
		T = dFC(:,:,t);
		vFC(:,t) = T(Isubdiag);
	end
	clear T
else
	vFC = dFC;
end

% Compute FCD matrix
switch metric
	case {'Pearson', 'Spearman', 'Kendall'}
		FCD = corr(vFC, 'Type',metric);
	case {'cosine', 'jaccard', 'hamming'}
		FCD = ones(size(squareform(pdist(vFC', metric)))) - squareform(pdist(vFC', metric));
	otherwise
		FCD = squareform(pdist(vFC', metric));
end

end

