% NB: this should be run from expts dir in github
s=pwd; [~,expdir]=fileparts(s);
assert(strcmp(expdir,'expts'),'%s: Must be run from expts directory.\n',mfilename);

nametags = {'B1040_1ts', 'B1040_2ts', 'B1040_3ts'}      % , 'B953_2ts', 'B953_3ts', 'B992_1ts'};     % , 'B987_5ts'};
approxReps = [5, 5, 10]   %, 15, 15, 15];     % , 30];

texturelabels = {'App','Bub','Spar','Star','Wind'};
statlabels = {'Noise','Marg','Full','Orig'};
durlabels = {'Short (800ms)', 'Long (5000ms)'};
nExemp = 3; % 3 exemplars of each texture family x stat model
nFams = numel(texturelabels);
nStats = numel(statlabels);
nDurs = numel(durlabels);

allFam = []; allStat = []; allDur = [];
nSites = numel(approxReps);
for sitenum = 1:nSites
  birdsite_nametag = nametags{sitenum};
  nReps = approxReps(sitenum);
  fprintf('%s: ~%d reps, ',birdsite_nametag,nReps)
  bs = processBirdsite(birdsite_nametag,nReps,0);  % no plotting!
  nClu(sitenum) = size(bs.durMean,1);
  fprintf('%d clusters\n',nClu(sitenum))

  allFam = [allFam; bs.famMean];
  allStat = [allStat; bs.statMean];
  allDur = [allDur; bs.durMean];
  % ignoring Ns and standard deviations for now, but they would be bs.xxxNs and bs.xxxStd
end

allfh = figure();
subplot(1,3,1), title('By Texture Family')
distributionPlot(gca,allFam,'color','g','showMM',4,'xNames',texturelabels)
ylabel('z-scored Firing Rate')
subplot(1,3,2), title('By Statistical Model')
distributionPlot(gca,allStat,'color','m','showMM',4,'xNames',statlabels)
subplot(1,3,3), title('By Duration')
distributionPlot(gca,allDur,'color','k','showMM',4,'xNames',durlabels)
suptitle(sprintf('Cluster Mean Firing Rates, %d sites, N = %d clusters',nSites,sum(nClu)) )
saveas(allfh, fullfile('analysis','figures','vlnFR_allBirds.png'));