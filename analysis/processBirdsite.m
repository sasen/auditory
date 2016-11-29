% this should be run from expts dir in github
% have the results dir ready to go

birdsite_nametag = 'B1040_3';

datdir = fullfile('DATA',birdsite_nametag);
resdir = fullfile('.','analysis','figures',birdsite_nametag);
ww = what(datdir);
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  cluStr = clu_fname(14:end-4);
  clu = str2double(cluStr);

  %% I. SPIKE RATE (only while stimulus on)
  [base, txtS, txtL, motifs] = processClusterFR(clu_fname, birdsite_nametag);  %% TODO fig numbers are going to be insane
  [figh,ByFam,ByStat] = boxplotClusterFR(txtS,txtL);
  figure(figh); suptitle([birdsite_nametag ' Clu ' cluStr])
  saveas(figh, fullfile('analysis','figures',birdsite_nametag, ['boxFR_' cluStr '.png']));

  %% II. Select Auditory Units
  psthbinsize = 0.020;   % in seconds, 20ms bins!
  [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize);

  %% III. PSTH (including pre/post period)
  psthbinsize = 0.002;   % in seconds, 2ms bins!
  smoothsize = 25;   % odd number of bins for PSTH smoothing
  [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(fullfile(datdir,clu_fname), psthbinsize);
  texturePSTH(lTEXpsth, smoothsize, 5, psthbinsize, sprintf('Cluster %d, Long Duration',clu))
  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_l.png',clu)))
  texturePSTH(sTEXpsth, smoothsize, 0.8, psthbinsize, sprintf('Cluster %d, Short Duration',clu))
  saveas(gcf, fullfile(resdir,sprintf('psth_%03d_s.png',clu)))

end % for each cluster


%-------- old but useful
% tAx = -2 + psthbinsize*[1:size(SILpsth,2)]; subplot(7,4,cnum), plot(tAx, SILpsth), title(['Cluster ' cluStr]), axis tight