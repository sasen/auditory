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

tsvfilename = fullfile(resdir,[birdsite_nametag,'_zfr_dataframe.txt']);
fid = fopen(tsvfilename,'w');
fprintf(fid, 'bird\tsite\tz\tlm\tap\tcluID\t');  % print dataframe column names (except stimnames)

ww = what(datdir);
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  cluStr = clu_fname(14:end-4);
  clu = str2double(cluStr);

  %% I. SPIKE RATE (only while stimulus on)
  [base, txtS, txtL, ztxtS, ztxtL, snamesS, snamesL] = processClusterFR(clu_fname, birdsite_nametag,nReps);
  if cnum == 1
    fprintf(fid,strjoin(snamesS','\t'));
    fprintf(fid,strjoin(snamesS','\t'));  %%%% obvious crap! long has empty cellstr for stimuli not presented TODO FIXME
%    assignin('base','snamesS',snamesS)
%    assignin('base','snamesL',snamesL)
    fprintf(fid,'some stim names!\n')
  end
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
  %---- for cluster x exemplar dataframe (avg over trials only)
  n_fold_exemp(cnum,:) = nanmean( reshape([txtS;txtL]', nReps, nStats*nExemp*nFams*2));  % 2 is nDurations
  zscore_exemp(cnum,:) = nanmean( reshape([ztxtS;ztxtL]', nReps, nStats*nExemp*nFams*2));
  fprintf(fid,'%s\t%s\t%d\t%d\t%d\t%s\t data for each exemplar!\n',birdsite_nametag,birdsite_nametag,2500,1500,2700,cluStr);
  for exem=1:numel(txtS)

%  fprintf(fid,deal(zscore_exemp(cnum,:)))
  end

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

fclose(fid);
assignin('base','zscore_exemp',zscore_exemp)

bsFamS = [birdsiteFamS zbirdsiteFamS];
bsFamL = [birdsiteFamL zbirdsiteFamL];
bsStatS = [birdsiteStatS zbirdsiteStatS];
bsStatL = [birdsiteStatL zbirdsiteStatL];


grandboxplots_figh=figure();


%%%%% zscored violins
subplot(1,2,1), hold on % by family
distributionPlot(gca,zbirdsiteFamS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',texturelabels)
distributionPlot(gca,zbirdsiteFamL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(z_bsFam,'labels',texturelabels)
title('By Texture Family')
axis tight 
ylabel('z-scored Firing Rate')
subplot(1,2,2), hold on % by stat model
distributionPlot(gca,zbirdsiteStatS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',statlabels)
distributionPlot(gca,zbirdsiteStatL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(z_bsStat,'labels',statlabels)
axis tight 
title('By Statistical Model')
figure(grandboxplots_figh); suptitle([birdsite_nametag ' Grand Mean cluster firing rates'])
saveas(grandboxplots_figh, fullfile('analysis','figures',birdsite_nametag, ['vlnFR_grandmean.png']));

%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight
% subplot(1,2,1),boxplot(birdsiteFam,'labels',texturelabels)   %,'plotstyle','compact')
% birdsiteFamS_means = nanmean(bsFamS)  % site-level means, lefthand = normalized change, righthand = zscored FR