% NB: this should be run from expts dir in github
s=pwd; [~,expdir]=fileparts(s);
assert(strcmp(expdir,'expts'),'%s: Must be run from expts directory.\n',mfilename);

nametags = {'B1040_1ts', 'B1040_2ts', 'B1040_3ts', 'B953_2ts', 'B953_3ts', 'B992_1ts'};     % , 'B987_5ts'};
approxReps = [5, 5, 10, 15, 15, 15];     % , 30];

texturelabels = {'App','Bub','Spar','Star','Wind'};
statlabels = {'Noise','Marg','Full','Orig'};
durlabels = {'Short (800ms)', 'Long (5000ms)'};
nExemp = 3; % 3 exemplars of each texture family x stat model
nFams = numel(texturelabels);
nStats = numel(statlabels);
nDurs = numel(durlabels);

allFamS = []; allFamL = []; allStatS = []; allStatL = [];
nSites = numel(approxReps);
for sitenum = 1:nSites
  birdsite_nametag = nametags{sitenum};
  nReps = approxReps(sitenum);
  fprintf('%s: ~%d reps, ',birdsite_nametag,nReps)
  [~,bsFamS,bsFamL,bsStatS,bsStatL] = processBirdsite(birdsite_nametag,nReps,0);  % no plotting!
  nClu(sitenum) = size(bsFamS,1);
  fprintf('%d clusters\n',nClu(sitenum))

  allFamS = [allFamS; bsFamS];
  allFamL = [allFamL; bsFamL];
  allStatS = [allStatS; bsStatS];
  allStatL = [allStatL; bsStatL];
end

% does it matter if I do this by Fam, Stat, or neither?
allDur = [mean(allFamS,2) mean(allFamL,2)];
allDur2 = [mean(allStatS,2) mean(allStatL,2)];

allDur'
allDur2'

allfh = figure();
subplot(1,3,1), title('By Texture Family'), hold on
distributionPlot(gca,allFamS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',texturelabels)
distributionPlot(gca,allFamL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
%     boxplot(allFam,'labels',texturelabels), axis tight
ylabel('z-scored Firing Rate')
subplot(1,3,2), title('By Statistical Model'), hold on
distributionPlot(gca,allStatS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',statlabels)
distributionPlot(gca,allStatL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
%     boxplot(allStat,'labels',statlabels), axis tight
subplot(1,3,3), title('By Duration')
distributionPlot(gca,allDur,'color','k','showMM',4,'xNames',durlabels)
suptitle(sprintf('Cluster Mean Firing Rates, %d sites, N = %d clusters',nSites,sum(nClu)) )
saveas(allfh, fullfile('analysis','figures','vlnFR_allBirds.png'));