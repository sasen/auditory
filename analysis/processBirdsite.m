function [grandboxplots_figh,bsFamS,bsFamL,bsStatS,bsStatL] = processBirdsite(birdsite_nametag,nReps)
% function [grandboxplots_figh,bsFamS,bsFamL,bsStatS,bsStatL] = processBirdsite(birdsite_nametag,nReps)
% Boxplots and cluster-level Firing Rate means for a birdsite, broken down by family and by stat model
% Also plots each cluster's mean FR by trial, but the psths are currently turned off. 
% In: birdsite_nametag (string): DATA directory name for sorted data e.g., 'B1040_3ts'
%     nReps (int): number of repetitions of each texture exemplar
% Out: grandboxplots_figh (int): figure handle for the grand box plot for this birdsite
%      bsFamS/L (#good_clusters x #familiesx2 float): mean cluster FR by family
%      bsStatS/L (#good_clusters x 8 float): mean cluster FR by stat model
%       	S = short textures, L = long (5s) textures
%		Left cols = baseline-normalized nfold change; Right cols = zscored raw FR
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
%  [base, txtS, txtL, motifs] = processClusterFR(clu_fname, birdsite_nametag);
  [base, txtS, txtL, ztxtS, ztxtL] = processClusterFR(clu_fname, birdsite_nametag,nReps);
  txtS(~isfinite(txtS)) = NaN;  % missing data = nan
  txtL(~isfinite(txtL)) = NaN;
  ztxtS(~isfinite(ztxtS)) = NaN;
  ztxtL(~isfinite(ztxtL)) = NaN;
  ByFamS = reshape(txtS', nReps*nStats*nExemp ,nFams);  % group short stimuli by family
  ByFamL = reshape(txtL', nReps*nStats*nExemp ,nFams);
  ByStatS = reshape(txtS, nReps*nFams*nExemp ,nStats);	% group short stimuli by stat model
  ByStatL = reshape(txtL, nReps*nFams*nExemp ,nStats);
  zByFamS = reshape(ztxtS', nReps*nStats*nExemp ,nFams);  % same for zscored FR data
  zByFamL = reshape(ztxtL', nReps*nStats*nExemp ,nFams);
  zByStatS = reshape(ztxtS, nReps*nFams*nExemp ,nStats);
  zByStatL = reshape(ztxtL, nReps*nFams*nExemp ,nStats);

  %% cluster-level means: for each statistic, by long / short / both
  birdsiteFamS(cnum,:) = nanmean(ByFamS);      
  birdsiteFamL(cnum,:) = nanmean(ByFamL);
  birdsiteStatS(cnum,:) = nanmean(ByStatS);
  birdsiteStatL(cnum,:) = nanmean(ByStatL);
  zbirdsiteFamS(cnum,:) = nanmean(zByFamS);    
  zbirdsiteFamL(cnum,:) = nanmean(zByFamL);
  zbirdsiteStatS(cnum,:) = nanmean(zByStatS);
  zbirdsiteStatL(cnum,:) = nanmean(zByStatL);
  n_bsFam(cnum,:)  = nanmean([ByFamS;   ByFamL]);  % mean collapsing across long and short
  n_bsStat(cnum,:) = nanmean([ByStatS;  ByStatL]);
  z_bsFam(cnum,:)  = nanmean([zByFamS;  zByFamL]);  % same for zscore
  z_bsStat(cnum,:) = nanmean([zByStatS; zByStatL]);

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

bsFamS = [birdsiteFamS zbirdsiteFamS];
bsFamL = [birdsiteFamL zbirdsiteFamL];
bsStatS = [birdsiteStatS zbirdsiteStatS];
bsStatL = [birdsiteStatL zbirdsiteStatL];


grandboxplots_figh=figure();

%%%%%  baseline-norm violin plots
subplot(2,2,1), hold on  %% by family
boxplot(log2(n_bsFam),'labels',texturelabels)
distributionPlot(gca,log2(birdsiteFamS),'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',texturelabels)
distributionPlot(gca,log2(birdsiteFamL),'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(log2(n_bsFam),'labels',texturelabels)
ylabel('Log_2 nfold change')
axis tight 
title('By Texture Family')
subplot(2,2,2), hold on  %% by stat model
distributionPlot(gca,log2(birdsiteStatS),'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',statlabels)
distributionPlot(gca,log2(birdsiteStatL),'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(log2(n_bsStat),'labels',statlabels)
axis tight 
title('By Statistical Model')

%%%%% zscored violins
subplot(2,2,3), hold on % by family
distributionPlot(gca,zbirdsiteFamS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',texturelabels)
distributionPlot(gca,zbirdsiteFamL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(z_bsFam,'labels',texturelabels)
axis tight 
ylabel('z-scored')
subplot(2,2,4), hold on % by stat model
distributionPlot(gca,zbirdsiteStatS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',statlabels)
distributionPlot(gca,zbirdsiteStatL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(z_bsStat,'labels',statlabels)
axis tight 
figure(grandboxplots_figh); suptitle([birdsite_nametag ' Grand Mean cluster firing rates'])
saveas(grandboxplots_figh, fullfile('analysis','figures',birdsite_nametag, ['vlnFRboth_grandmean.png']));

%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight
% subplot(1,2,1),boxplot(birdsiteFam,'labels',texturelabels)   %,'plotstyle','compact')
% birdsiteFamS_means = nanmean(bsFamS)  % site-level means, lefthand = normalized change, righthand = zscored FR