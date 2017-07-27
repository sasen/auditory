%% B1040_3ts
%% clu 18
%% orig App_s4 vs Str_s2
load('DATA/B1040_3ts/sptrains_unit18.mat');

%%%%%%% plot several ways, using plotSpikeRaster
byStim = rasters';   % just like python rasters, grouped by alphabetized stimulus name
figure
plotSpikeRaster(byStim,'PlotType','vertline','XLimForCell',[-2 9]);
title('By Alphabetized Stim Exemplar (Sorta by stat)')

% by time  *** note trialID is ZERO-INDEXED BECAUSE PYTHON
trID = trialID+1;
[sorted, sortIdx] = sort(trID);
figure
plotSpikeRaster(byStim(sortIdx),'PlotType','vertline','XLimForCell',[-2 9]);
title('By Time (true Trial ID number)')

%%%%%%% FRAGILE %%%%%%%%%%%%%%
fid = fopen('stimsReorderedByFamily.csv');
C = textscan(fid, '%s%d%d%s%s%s%d%s%s','Delimiter',',');  %% 1=stimname, 3=sortbyfam
fclose(fid);
famSortStimNames = C{1};  %% ack, these are CELL not char matrix anymore.
famSortIdx=C{3};
figure
plotSpikeRaster(byStim(famSortIdx),'PlotType','vertline','XLimForCell',[-2 9]);
title('By Family')
