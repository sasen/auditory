%% analysis script: findShortInLong
%% scope: exploratory, cell-level, using raster (and audio) data, only on norm (orig) texture stimuli
%% goal: 2 things. (1) 
%% requirements: run from auditory/expts/. subdirs DATA, audio, analysis organized as expected

birdsite='B1040_3ts'; cellID='58';   %% B1040_3ts // clu 18
load(fullfile('DATA',birdsite,['sptrains_unit',cellID,'.mat']));    %% load('DATA/B1040_3ts/sptrains_unit18.mat');
figsDir = fullfile('analysis','figures',birdsite, 'findShortInLong', ['cell' cellID]);
mkdir(figsDir);

%% Trial indexes for rasters by (alphabetized) stimname
%%      l1/71    , s1	   , s2       , s3 	 , s4		    
idxApp=[1091:1100, 1151:1160, 1201:1210, 1251:1260, 1301:1310];
idxBub=[1081:1090, 1161:1170, 1211:1220, 1261:1270, 1311:1320];
idxSpa=[1121:1130, 1171:1180, 1221:1230, 1271:1280];
idxSta=[1131:1140, 1181:1190, 1231:1240, 1281:1290];
idxWin=[1141:1150, 1191:1200, 1241:1250, 1291:1300];
%% Flck 1101:1110
%% LSng 1111:1120

bird = strsplit(birdsite,'_');
audioDir = fullfile('audio','STIMULI',bird{1});
fam.name = {'Applause', 'Bubbling_water', 'Sparrows', 'Starlings', 'Wind_whistling'};
fam.long = {'l',	'7',	    'l', 	'l',	     'l'};
fam.idx = {idxApp,	idxBub,	    idxSpa,	idxSta,	     idxWin};
fam.trls = {10*ones(5,1),10*ones(5,1),10*ones(4,1),10*ones(4,1),10*ones(4,1)};    

%% handle non-spiking trials (say it spikes at -2)
for rr = 1:numel(rasters)
  if isempty(rasters{rr})
    rasters{rr} = [-2];
  end  % empty
end % for trials

%%%%%%% naively plot using plotSpikeRaster
% 1. By Stat & Dur
byStim = rasters';   % just like python rasters, grouped by alphabetized stimulus name
bystatFH = figure();
plotSpikeRaster(byStim,'PlotType','vertline','XLimForCell',[-2 9]);
title(['Cell ' cellID ': By Stat Model and Duration'])
set(gca, 'FontSize', 14)
ylabel(strjoin({'\phi', 'Norm                   ', 'Noise         ', 'Marg          ', 'Full   '}, ' '));
saveas(bystatFH, fullfile(figsDir, ['allRastersByStat_' cellID '.png']));

% 2. By time  *** note trialID is ZERO-INDEXED BECAUSE PYTHON
trID = trialID+1;
[sorted, sortIdx] = sort(trID);
bytimeFH = figure();
plotSpikeRaster(byStim(sortIdx),'PlotType','vertline','XLimForCell',[-2 9]);
title(['Cell' cellID ': By Time'])
set(gca, 'FontSize', 14)
ylabel('Trial number');
saveas(bytimeFH, fullfile(figsDir, ['allRastersByTime_' cellID '.png']));

%%%%%%% FRAGILE %%%%%%%%%%%%%%
% 3. By Family
fid = fopen('stimsReorderedByFamily.csv');
C = textscan(fid, '%s%d%d%s%s%s%d%s%s','Delimiter',',');  %% 1=stimname, 3=sortbyfam
fclose(fid);
%famSortStimNames = C{1};  %% ack, these are CELL not char matrix anymore.
famSortIdx=C{3};
byfamFH = figure();
plotSpikeRaster(byStim(famSortIdx),'PlotType','vertline','XLimForCell',[-2 9]);
title(['Cell', cellID,': All Rasters By Family ' birdsite]); grid minor
set(gca, 'FontSize', 14)
ylabel(strjoin({fam.name{end:-1:1}}, '       '));
saveas(byfamFH, fullfile(figsDir, ['allRastersByFam_' cellID '.png']));


idxNorm = [idxApp idxBub idxSpa idxSta idxWin];
%normStimnames = stims(idxNorm,:);
normbyfamFH = figure();
plotSpikeRaster(byStim(idxNorm),'PlotType','vertline','XLimForCell',[-2 9]);
title(['Norm Rasters By Family ' birdsite cellID]); grid minor
set(gca, 'FontSize', 14)
ylabel(strjoin({fam.name{end:-1:1}}, '   '));
saveas(normbyfamFH, fullfile(figsDir, ['normRastersByFam_' cellID '.png']));

%%% align audio for each family, then align rasters for this cell
numFams = numel(fam.name);
for ff = 1:numFams
  [fam.delRas{ff}, fam.delays{ff}, fam.lineX{ff}, fam.lineY{ff}] = alignNormStim(audioDir, figsDir, fam.name{ff}, fam.long{ff}, byStim(fam.idx{ff}), fam.trls{ff});
end % for ff

save(fullfile(figsDir, ['normStimFindingAnalysis' birdsite cellID '.mat']));
