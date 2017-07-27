%% analysis script: findShortInLong
%% scope: exploratory, cell-level, using raster (and audio) data, only on norm (orig) texture stimuli
%% goal: 2 things. (1) 
%% requirements: run from auditory/expts/. subdirs DATA, audio, analysis organized as expected

birdsite='B1040_3ts'; cellID='54';   %% B1040_3ts // clu 18
load(fullfile('DATA',birdsite,['sptrains_unit',cellID,'.mat']));    %% load('DATA/B1040_3ts/sptrains_unit18.mat');

%% Trial indexes for rasters by (alphabetized) stimname
%%      l1/71    , s1	   , s2       , s3 	 , s4		    
idxApp=[1091:1100, 1151:1160, 1201:1210, 1251:1260, 1301:1310];
idxBub=[1081:1090, 1161:1170, 1211:1220, 1261:1270, 1311:1320];
idxSpa=[1121:1130, 1171:1180, 1221:1230, 1271:1280];
idxSta=[1131:1140, 1181:1190, 1231:1240, 1281:1290];
idxWin=[1141:1150, 1191:1200, 1241:1250, 1291:1300];
%% Flck 1101:1110
%% LSng 1111:1120

%%%%%%% naively plot using plotSpikeRaster
byStim = rasters';   % just like python rasters, grouped by alphabetized stimulus name
idxNorm = [idxApp idxBub idxSpa idxSta idxWin];
normStimnames = stims(idxNorm,:);
figure();
plotSpikeRaster(byStim(idxNorm),'PlotType','vertline','XLimForCell',[-2 9]);
title('Norm Rasters By Family'); grid minor

bird = strsplit(birdsite,'_');
audioDir = fullfile('audio','STIMULI',bird{1});
fam.name = {'Applause', 'Bubbling_water', 'Sparrows', 'Starlings', 'Wind_whistling'};
fam.long = {'l',	'7',	    'l', 	'l',	     'l'};
fam.idx = {idxApp,	idxBub,	    idxSpa,	idxSta,	     idxWin};
fam.trls = {10*ones(5,1),10*ones(5,1),10*ones(4,1),10*ones(4,1),10*ones(4,1)};    

numFams = numel(fam.name);
for ff = 1:numFams
  [fam.delRas{ff}, fam.delays{ff}, fam.lineX{ff}, fam.lineY{ff}] = alignNormStim(audioDir, fam.name{ff}, fam.long{ff}, byStim(fam.idx{ff}), fam.trls{ff});
end % for ff

save(['normStimFindingAnalysis' birdsite cellID '.mat']);
