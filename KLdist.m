function [KL_PQ, KL_QP] = KLdist(Q, P)
% KLDIST computes the KL distance between P and Q in both directions.  This
% allows us to quantify the information gain between states, i.e. the
% amount of information gained by switching from Q to P (KL_QP) or from P
% to Q (KL_PQ).
%	Since the KL divergence is a non-symmetric function, both directions 
% are necessary in order to obtain a full description of the differences.
% Most commonly, one measures the gain from Q to P, as Q is taken as the
% "prior" state and P as the "posterior" state.
%	INPUTS:
%		P: probability distribution.  By convention, P is the "empirical"
%			distribution, i.e. the distribution computed from the data.
%		Q: probability distribution.  By convention, Q is the "test"
%			distribution, i.e. an (attempted) approximation of P.
%	OUTPUTS:
%		KL_PQ: the KL disTh3H@rdWay
tance from P to Q
%		KL_QP: the KL distance from Q to P

KL_PQ = sum(P.*log(P./Q));
KL_QP = sum(Q.*log(Q./P));

end

