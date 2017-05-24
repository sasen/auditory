function bs = processBirdsite(birdsite_nametag,nReps,PLOT_COLORMAPS)
% function [grandboxplots_figh,bsFamS,bsFamL,bsStatS,bsStatL] = processBirdsite(birdsite_nametag,nReps,PLOT_COLORMAPS)
% Boxplots and cluster-level Firing Rate means for a birdsite, broken down by family and by stat model
% Also can plot each cluster's mean FR by trial, but the psths are currently turned off. 
% In: birdsite_nametag (string): DATA directory name for sorted data e.g., 'B1040_3ts'
%     nReps (int): number of repetitions of each texture exemplar
%     PLOT_COLORMAPS (logical): 0=skip plotting, 1=plot and save FR colormaps for each cluster
% Out: grandboxplots_figh (int): figure handle for the grand box plot for this birdsite
%      bsFamS/L (#good_clusters x #familiesx2 float): mean cluster FR by family
%      bsStatS/L (#good_clusters x 8 float): mean cluster FR by stat model
%       	S = short textures, L = long (5s) textures
% Eventually this has to handle the diversity of stimuli better %% TODO!
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
fprintf(fid, 'bird\tbirdsite\tAP\tML\tZ\tcluID\tstimname\tstat\tdur\tfamily\trep\tfiringrate\n');  % print dataframe column names

%% Set stereotactic coordinates for each site
switch birdsite_nametag
 case {'B987_5','B987_5ts'}
  apmlz = [1200 1200 3700];    %% Lft
 case {'B1040_1','B1040_1ts'}
  apmlz = [1050  700 3200];    %% Lft
 case {'B1040_2','B1040_2ts'}
  apmlz = [1050  700 4200];    %% Lft
 case {'B1040_3','B1040_3ts'}
  apmlz = [1050  700 5000];    %% Lft
 case {'B992_1','B992_1ts'}
  apmlz = [1500  500 1900];    %% Rgt
 case {'B953_2','B953_2ts'}
  apmlz = [  20 1700 2926];    %% Lft
 case {'B953_3','B953_3ts'}
  apmlz = [  20 1700 3236];    %% Lft
 otherwise
  error('%s: Unknown birdsite %s!', mfilename, birdsite_nametag);
end % switch bs
birdID = strsplit(birdsite_nametag,'_');  % actually birdID{1}
dfStr_birdsite = sprintf('%s\t%s\t%d\t%d\t%d\t',birdID{1},birdsite_nametag,apmlz(1),apmlz(2),apmlz(3));

ww = what(datdir);
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  if isempty(strfind(clu_fname,'sptrains_unit'))  % make sure this matfile is a cluster's rasters
    continue;   %% skip other weird matfiles
  end
  cluStr = clu_fname(14:end-4);
  dfStr_clu = sprintf('%s%s\t', dfStr_birdsite, cluStr);

  %% I. SPIKE RATE (only while stimulus on)
  [base, txtS, txtL, snamesS, snamesL, textures] = processClusterFR(clu_fname, birdsite_nametag,nReps,PLOT_COLORMAPS,fid,dfStr_clu);
  txtS(~isfinite(txtS)) = NaN;  % missing data = nan
  txtL(~isfinite(txtL)) = NaN;
  ByFamS = reshape(txtS', nReps*nStats*nExemp ,nFams);  % group short stimuli by family
  ByFamL = reshape(txtL', nReps*nStats*nExemp ,nFams);
  ByStatS = reshape(txtS, nReps*nFams*nExemp ,nStats);	% group short stimuli by stat model
  ByStatL = reshape(txtL, nReps*nFams*nExemp ,nStats);

  %% cluster-level means: long / short / both
  bsFamS(cnum,:) = nanmean(ByFamS);      
  bsFamL(cnum,:) = nanmean(ByFamL);
  bsStatS(cnum,:) = nanmean(ByStatS);
  bsStatL(cnum,:) = nanmean(ByStatL);
  bsFam(cnum,:)  = nanmean([ByFamS;   ByFamL]);  % mean collapsing across long and short
  bsStat(cnum,:) = nanmean([ByStatS;  ByStatL]);

  [bs.durMean(cnum,:), bs.durStd(cnum,:), bs.durNs(cnum,:)] = avgByTextureVariable(textures,1); % by duration
  [bs.famMean(cnum,:), bs.famStd(cnum,:), bs.famNs(cnum,:)] = avgByTextureVariable(textures,2); % by family
  [bs.statMean(cnum,:), bs.statStd(cnum,:), bs.statNs(cnum,:)] = avgByTextureVariable(textures,3); % by statmodel


%   %% II. Select Auditory Units
%   psthbinsize = 0.020;   % in seconds, 20ms bins!
%   [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize,nReps);

%  %% III. PSTH (including pre/post period)
%  clu = str2double(cluStr);
%  psthbinsize = 0.002;   % in seconds, 2ms bins!
%  smoothsize = 25;   % odd number of bins for PSTH smoothing
%  [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize,nReps);
%  texturePSTH(lTEXpsth, smoothsize, 5, psthbinsize, sprintf('Cluster %d, Long Duration',clu))
%  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_l.png',clu)))
%  texturePSTH(sTEXpsth, smoothsize, 0.8, psthbinsize, sprintf('Cluster %d, Short Duration',clu))
%  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_s.png',clu)))

end % for each cluster

fclose(fid);

grandboxplots_figh=figure();
subplot(1,2,1), title('By Texture Family'), hold on
distributionPlot(gca,bsFamS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',texturelabels)
distributionPlot(gca,bsFamL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(bsFam,'labels',texturelabels), axis tight 
ylabel('z-scored Firing Rate')
subplot(1,2,2), title('By Statistical Model'), hold on
distributionPlot(gca,bsStatS,'widthDiv',[2 1],'histOri','left','color','g','showMM',4,'xNames',statlabels)
distributionPlot(gca,bsStatL,'widthDiv',[2 2],'histOri','right','color','c','showMM',4)
boxplot(bsStat,'labels',statlabels), axis tight 
figure(grandboxplots_figh); suptitle([birdsite_nametag ' Grand Mean cluster firing rates']);
saveas(grandboxplots_figh, fullfile('analysis','figures',birdsite_nametag, ['vlnFR_birdsitegrandmean.png']));

%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight
% subplot(1,2,1),boxplot(birdsiteFam,'labels',texturelabels)   %,'plotstyle','compact')
