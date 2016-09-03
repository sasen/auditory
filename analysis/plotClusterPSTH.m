function plotClusterPSTH(clu, birdsite_nametag)
% plotClusterPSTH plots and saves figures for texture stimuli, at least!
%  ... more coming soon!
% function plotClusterPSTH(clu, birdsite_nametag)
% clu: int, cluster number eg 31
% birdsite_nametag: str, eg 'B1040_3'
% run this from expts dir in github (needs DATA and analysis subdirs)
% saved in results dir: analysis/figures/{birdsite_nametag}/ <-- make sure exists!

binsize = 0.002;   % in seconds, 2ms bins!
smoothsize = 25;   % odd number of bins for PSTH smoothing

resdir = fullfile('.','analysis','figures',birdsite_nametag);
clu_fname = fullfile('.','DATA',birdsite_nametag, sprintf('sptrains_unit%d.mat',clu));
[SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(clu_fname, binsize);


%figure(6); hold on
tAx = -2 + binsize*[1:size(SILpsth,2)];
%plot(tAx, SILpsth)
%plot(tAx, smooth(SILpsth),'r')


texturePSTH(lTEXpsth, smoothsize, 5, binsize, sprintf('Cluster %d, Long Duration',clu))
saveas(gcf, fullfile(resdir,sprintf('psth_%03d_l.png',clu)))

texturePSTH(sTEXpsth, smoothsize, 0.8, binsize, sprintf('Cluster %d, Short Duration',clu))
saveas(gcf, fullfile(resdir,sprintf('psth_%03d_s.png',clu)))
