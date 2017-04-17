function [grandboxplots_figh,birdsiteFam,birdsiteStat] = processBirdsite(birdsite_nametag,nReps)
% function [grandboxplots_figh,birdsiteFam,birdsiteStat] = processBirdsite(birdsite_nametag,nReps)
% Boxplots and cluster-level Firing Rate means for a birdsite, broken down by family and by stat model
% Also plots each cluster's mean FR by trial, but the psths are currently turned off. 
% In: birdsite_nametag (string): DATA directory name for sorted data e.g., 'B1040_3ts'
% Out: garndboxplots_figh (int): figure handle for the grand box plot for this birdsite
%      birdsiteFam (#good_clusters x #families float): mean cluster FR by family
%      birdsiteStat (#good_clusters x 4 float): mean cluster FR by stat model
% Eventually this has to handle the diversity of stimuli & numtrials better %% TODO!
% NB: this should be run from expts dir in github
s=pwd; [~,expdir]=fileparts(s);
assert(strcmp(expdir,'expts'),'%s: Must be run from expts directory.\n',mfilename);

texturelabels = {'App','Bub','Spar','Star','Wind'};
statlabels = {'Noise','Marg','Full','Orig'};

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
  [figh,ByFam,ByStat] = boxplotClusterFR(txtS,txtL,nReps);
  birdsiteFam(cnum,:) = nanmean(ByFam);
  birdsiteStat(cnum,:) = nanmean(ByStat);

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
subplot(1,2,1),boxplot(birdsiteFam,'labels',texturelabels)   %,'plotstyle','compact')
subplot(1,2,2),boxplot(birdsiteStat,'labels',statlabels)     %,'plotstyle','compact')
birdsiteFam_means = nanmean(birdsiteFam)
birdsiteStat_means = nanmean(birdsiteStat)
figure(grandboxplots_figh); suptitle([birdsite_nametag ' Grand Mean FR'])
saveas(grandboxplots_figh, fullfile('analysis','figures',birdsite_nametag, ['boxFR_grandmean.png']));



%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight