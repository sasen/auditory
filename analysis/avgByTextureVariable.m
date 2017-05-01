function [means, stds, Ns] = avgByTextureVariables(t,dimnum)
% function [means, stds, Ns] = avgByTextureVariables(t,dimnum)
% t: textures 5-d array:  dur,fam,stat,exemp,reps, result of processClusterFR.m
% dimnum: 1 through 5
%   1 = bydur: eg [short long]
%   2 = byfam: eg [App Bub Sp St Win]
%   3 = bystat: eg [noise marg full orig]
%   4 = total garbage, since exemplar number means nothing
%   5 = i guess this could help show a time effect, since repetitions are in time order
% means/stds: mean/std of all trials of the relevant type
% Ns: how many trials contributed to each of these cluster means

nTot = numel(t);
nValues = size(t,dimnum);

for nn = 1:nValues
  shifted = shiftdim(t, dimnum-1);   % put variable of interest in first dimension for convenience
  trialsforthisvalue = reshape(shifted(nn,:,:,:,:), 1, nTot/nValues);  % all of those trials in a row vector
  means(nn) = nanmean(trialsforthisvalue);
  stds(nn) = nanstd(trialsforthisvalue);
  Ns(nn) = sum(isfinite(trialsforthisvalue));
end   % for each value
