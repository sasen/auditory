% this should be run from expts dir in github
% have the results dir ready to go

birdsite_nametag = 'B1040_3';
ww = what('DATA');
for cnum = 1:numel(ww.mat)  % going through good clusters
  clustr= strsplit(ww.mat{cnum}(14:end),'.');
  clu = str2double(clustr{1});
  plotClusterPSTH(clu, birdsite_nametag)
end % for each cluster