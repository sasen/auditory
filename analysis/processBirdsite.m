% this should be run from expts dir in github
% have the results dir ready to go

birdsite_nametag = 'B1040_3';
ww = what(fullfile('DATA',birdsite_nametag));
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  cluStr = clu_fname(14:end-4);
  clu = str2double(cluStr);
  [base, txtS, txtL, motifs] = processClusterFR(clu_fname, birdsite_nametag);  %% TODO fig numbers are going to be insane
  [figh,ByFam,ByStat] = boxplotClusterFR(txtS,txtL);
  figure(figh); suptitle([birdsite_nametag ' Clu ' cluStr])
  saveas(figh, fullfile('analysis','figures',birdsite_nametag, ['boxFR_' cluStr '.png']));

  plotClusterPSTH(clu, birdsite_nametag);
end % for each cluster

