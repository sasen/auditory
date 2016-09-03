% this should be run from expts dir in github
% have the results dir ready to go

birdsite_nametag = 'B1040_3';
ww = what(fullfile('DATA',birdsite_nametag));
for cnum = 1:numel(ww.mat)  % going through good clusters
  clu_fname = ww.mat{cnum};
  clu = str2double(clu_fname(14:end-4));
  processClusterFR(clu_fname, birdsite_nametag);  %% TODO fig numbers are going to be insane
  plotClusterPSTH(clu, birdsite_nametag);
end % for each cluster

