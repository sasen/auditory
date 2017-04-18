function [grandboxplots_figh,birdsiteFamS,birdsiteFamL,birdsiteStatS,birdsiteStatL] = processBirdsite(birdsite_nametag,nReps)
% function [grandboxplots_figh,birdsiteFam,birdsiteStat] = processBirdsite(birdsite_nametag,nReps)
% Boxplots and cluster-level Firing Rate means for a birdsite, broken down by family and by stat model
% Also plots each cluster's mean FR by trial, but the psths are currently turned off. 
% In: birdsite_nametag (string): DATA directory name for sorted data e.g., 'B1040_3ts'
%     nReps (int): number of repetitions of each texture exemplar
% Out: garndboxplots_figh (int): figure handle for the grand box plot for this birdsite
%      birdsiteFam (#good_clusters x #families float): mean cluster FR by family
%      birdsiteStat (#good_clusters x 4 float): mean cluster FR by stat model
% Eventually this has to handle the diversity of stimuli & numtrials better %% TODO!
% NB: this should be run from expts dir in github
s=pwd; [~,expdir]=fileparts(s);
assert(strcmp(expdir,'expts'),'%s: Must be run from expts directory.\n',mfilename);

texturelabels = {'App','Bub','Spar','Star','Wind'};
statlabels = {'Noise','Marg','Full','Orig'};
nFams = numel(texturelabels);
nStats = numel(statlabels);
nExemp = 3; % 3 exemplars of each texture family x stat model

datdir = fullfile('DATA',birdsite_nametag);
assert(exist(datdir,'dir')==7,'%s: %s directory cannot be found.\n',mfilename,datdir);
resdir = fullfile('.','analysis','figures',birdsite_nametag);
mkdir(resdir);   % in case doesn't already exist
ww = what(datdir);
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  cluStr = clu_fname(14:end-4);
  clu = str2double(cluStr);

  %% I. SPIKE RATE (only while stimulus on)
%  [base, txtS, txtL, motifs] = processClusterFR(clu_fname, birdsite_nametag);  %% TODO fig numbers are going to be insane
  [base, txtS, txtL] = processClusterFR(clu_fname, birdsite_nametag,nReps);  %% TODO fig numbers are going to be insane
  txtS(~isfinite(txtS)) = NaN;  % missing data = nan
  txtL(~isfinite(txtL)) = NaN;
  ByFamS = reshape(txtS', nReps*nStats*nExemp ,nFams);  % group short stimuli by family
  ByFamL = reshape(txtL', nReps*nStats*nExemp ,nFams);
  ByStatS = reshape(txtS, nReps*nFams*nExemp ,nStats);	% group short stimuli by stat model
  ByStatL = reshape(txtL, nReps*nFams*nExemp ,nStats);

  birdsiteFamS(cnum,:) = nanmean(ByFamS);
  birdsiteFamL(cnum,:) = nanmean(ByFamL);
  birdsiteStatS(cnum,:) = nanmean(ByStatS);
  birdsiteStatL(cnum,:) = nanmean(ByStatL);

%   [figh,ByFam,ByStat] = boxplotClusterFR(txtS,txtL,nReps);
%   figure(figh); suptitle([birdsite_nametag ' Clu ' cluStr])
%   saveas(figh, fullfile('analysis','figures',birdsite_nametag, ['boxFR_' cluStr '.png']));

%   %% II. Select Auditory Units
%   psthbinsize = 0.020;   % in seconds, 20ms bins!
%   [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize,nReps);

%  %% III. PSTH (including pre/post period)
%  psthbinsize = 0.002;   % in seconds, 2ms bins!
%  smoothsize = 25;   % odd number of bins for PSTH smoothing
%  [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize,nReps);
%  texturePSTH(lTEXpsth, smoothsize, 5, psthbinsize, sprintf('Cluster %d, Long Duration',clu))
%  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_l.png',clu)))
%  texturePSTH(sTEXpsth, smoothsize, 0.8, psthbinsize, sprintf('Cluster %d, Short Duration',clu))
%  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_s.png',clu)))

end % for each cluster

grandboxplots_figh=figure();
%% violin plots by family
subplot(1,2,1),
distributionPlot(log2(birdsiteFamS),'widthDiv',[2 1],'histOri','left','color','b','showMM',4,'xNames',texturelabels)
distributionPlot(gca,log2(birdsiteFamL),'widthDiv',[2 2],'histOri','right','color','k','showMM',4)
%% violin plots by stat model
subplot(1,2,2),
distributionPlot(log2(birdsiteStatS),'widthDiv',[2 1],'histOri','left','color','b','showMM',4,'xNames',statlabels)
distributionPlot(gca,log2(birdsiteStatL),'widthDiv',[2 2],'histOri','right','color','k','showMM',4)
%distributionPlot(gca,log2(birdsiteStatL),'histOpt',2,'widthDiv',[2 2],'histOri','right','color','k','showMM',4)

%% group-level means
birdsiteFamS_means = nanmean(birdsiteFamS)
birdsiteFamL_means = nanmean(birdsiteFamL)
birdsiteStatS_means = nanmean(birdsiteStatS)
birdsiteStatL_means = nanmean(birdsiteStatL)
figure(grandboxplots_figh); suptitle([birdsite_nametag ' Log_2 Grand Mean FR nfold-increase'])
saveas(grandboxplots_figh, fullfile('analysis','figures',birdsite_nametag, ['vlnFRnfold_grandmean.png']));



%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight
% subplot(1,2,1),boxplot(birdsiteFam,'labels',texturelabels)   %,'plotstyle','compact')
