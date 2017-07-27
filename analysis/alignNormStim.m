function [delRasters, del, lineX, lineY] = alignNormStim(audioDir, name, longChar, ras, numTrials)
% function [delRasters, del, lineX, lineY] = alignNormStim(audioDir, name, longChar, ras, numTrials)
% only assumptions are shortDur=0.8s, longDur = 5s (or 7s), and pre-post = 2s
% OH, AND BIRDSITE_NAMETAG is hardcoded. Also cluID isn't included in figure titles, which is stupid
birdsite_nametag = 'B1040_3ts';
shortDur = 0.8;  % seconds
xprepost = 2;
switch longChar
  case 'l'
    xmax = 5 + xprepost;
  case '7'
    xmax = 7 + xprepost;
end %% switch

numRasters = numel(ras);
assert(numRasters==sum(numTrials),'%s: number of rasters %d and numTrials summed %d do not match.\n',mfilename,numRasters,sum(numTrials))
numExemplars = numel(numTrials) - 1;
lastTrial = cumsum(numTrials);    %% eg [10 20 30 40]'

[long, fs] = audioread(fullfile(audioDir,['norm_' longChar '1_' name '.wav']));
skip_amt = shortDur * fs;
mid = numel(long)/2;

delRasters = cell(numRasters,1);
delRasters(1:numTrials(1)) = ras(1:numTrials(1));
audioFH = figure();
for ee = 1:numExemplars
  [short{ee}, fs] = audioread(fullfile(audioDir,['norm_s' num2str(ee) '_' name '.wav']));
  del(ee) = finddelay(short{ee},long)/fs;
  subplot(numExemplars,1,ee), plot([1:numel(short{ee})]/fs, short{ee}), hold on
  longmax = del(ee)*fs + skip_amt;
  longmin = del(ee)*fs;
  if longmax < numel(long)
    if longmin > 0
      plot([1:skip_amt]/fs, long(del(ee)*fs+1 : longmax)); axis tight
    else
      matchsamps = (shortDur+del(ee))*fs;
      shortSamps = numel(short{ee});
      matchtime = [shortSamps - matchsamps:shortSamps]/fs;
      plot(matchtime, long(1:matchsamps+1)); axis tight
    end
  else
    matchsamps = numel(long) - longmin;
    matchtime = [1:matchsamps+1]/fs;
    plot(matchtime, long(longmin+1 : end)); axis tight
  end  % if longmax
  text(0.1,0,num2str(del(ee)),'FontSize',20)

  for tr = 1:numTrials(ee) 
    trialOffset = tr + lastTrial(ee);
    delRasters{trialOffset} = del(ee) + ras{trialOffset};
  end  % for tr
end  % for ee
suptitle(['Audio Alignment for ' name])

rasterFH = figure();
plotSpikeRaster(delRasters,'PlotType','vertline','XLimForCell',[-xprepost xmax]); hold on
title(['Delayed Raster Alignment for ' name])
longX = [0,0; xmax-xprepost,xmax-xprepost];
longY = [1,numTrials(1); 1,numTrials(1)];
line(longX',longY','LineWidth',2,'Color','green')
lineX = longX; lineY = longY;   % save non-transposed line vertices for future plotting

stimOnX = [0 0; shortDur shortDur];
for ee = 1:numExemplars
  d=del(ee);
  exemX = repmat(stimOnX+del(ee),2,1);
  exemY = [repmat([1,numTrials(1)],2,1); repmat([1,numTrials(ee)]+lastTrial(ee),2,1)];
  line(exemX', exemY','LineWidth',2,'Color','red')  
  lineX = [lineX; exemX];     % add to saved non-transposed line vertices for future plotting
  lineY = [lineY; exemY];   
end % for ee

saveas(audioFH, fullfile('analysis','figures',birdsite_nametag, ['audioAlign_' name '.png']));
saveas(rasterFH, fullfile('analysis','figures',birdsite_nametag, ['rasterAlign_' name '.png']));  % TODO: clu ID needed!
