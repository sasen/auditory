% NB: this should be run from expts dir in github
s=pwd; [~,expdir]=fileparts(s);
assert(strcmp(expdir,'expts'),'%s: Must be run from expts directory.\n',mfilename);

nametags = {'B1040_1ts', 'B1040_2ts', 'B1040_3ts', 'B953_2ts', 'B953_3ts', 'B992_1ts'}     % , 'B987_5ts'}
approxReps = [5, 5, 10, 15, 15, 15]     % , 30]

nSites = numel(approxReps);
for sitenum = 1:nSites
  birdsite_nametag = nametags{sitenum}
  nReps = approxReps(sitenum);
  [~,bsFamS,bsFamL,bsStatS,bsStatL] = processBirdsite(birdsite_nametag,nReps,0);  % no plotting!
end