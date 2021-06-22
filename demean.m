function [demeaned] = demean(timeseries, tdim)
% DEMEAN removes the temporal mean value.  Can set time dimension; default
%	assumes time is second (row) dimension

% Set default time dimension
if ~exist('tdim', 'var')
	tdim = 2;
end

% Compute the mean of each row
timemean = mean(timeseries, tdim);

% Determine how to replicate mean vector
ivec = ones(1,ndims(timeseries));
ivec(tdim) = size(timeseries,tdim);

% Convert mean vector to matrix
timemean = repmat(timemean, ivec);

% Remove mean from timeseries
demeaned = timeseries - timemean;

end

