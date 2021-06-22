function [bfilt, afilt] = narrowband(delt, varargin)
% NARROBAND provides a default narrowband filter for BOLD signals
%	

if isempty(varargin)
	k=2;				% 2nd order butterworth filter
	fnq=1/(2*delt);		% Nyquist frequency
	flp = .04;			% lowpass frequency of filter
	fhi = .07;			% highpass frequency of filter
	Wn=[flp/fnq fhi/fnq];			% butterworth bandpass non-dimensional frequency
	[bfilt, afilt] = butter(k,Wn);	% construct the filter
end

end

