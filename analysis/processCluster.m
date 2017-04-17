function [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(clu_fname, binsize,nReps)
% processCluster computes lots of PSTHs for later plotting
% [SILpsth, sTEXpsth, lTEXpsth, sMOTpsth, lMOTpsth] = processCluster(clu_fname, binsize,nReps)
% clu_fname: str, matfile like 'sptrains_unit31.mat'
% binsize: double, PSTH bin size in milliseconds (eg 0.002 for 2ms bins)
% XXXXpsth: arrays with psths for...
%   SIL: silence (just 1)
%   sTEX, lTEX: short, long textures
%   sMOT, lMOT: short, long motifs
%% TODO FIXME SS : deal with birdsites with misnamed stimuli! eg verify length in tTimes

load(clu_fname);
tTimes = round(tTimes,2,'significant');   %% unique(tTimes(:,3)); % 0.8, 1, 5, 6, 7

%% Go through each stimulus
stims = cellstr(stims);  % convert char array to cell array of char vectors
stimnames = unique(stims);
for s = 1:length(stimnames)
  stim = stimnames{s};
  stim_idx = find(strcmp(stim,stims)); % trials using that stim
  rs = rasters(stim_idx);
  mytimes = tTimes(stim_idx(1),:);
  totalTime = abs(mytimes(1)) + mytimes(end);  % in seconds
  psth = hist([rs{:}], totalTime/binsize); %%% THIS IS WRONG

  %%% Create and go through tag particles
  tags = strsplit(stim,'_');
  motifnum = str2double(tags{1});    % if it's a motif, get its number.

  if isfinite(motifnum)		     %% 1. handle motifs
    switch mytimes(3)         % motif duration
      case 1,
        sMOTpsth(motifnum,:) = psth;
      case 6,
        lMOTpsth(motifnum,:) = psth;
      otherwise,
        error('%s: Motif stim %s has a broken duration.\n', mfilename, stim)
    end  % switch motif duration

  elseif strcmp('silence',tags{1})   %% 2. handle silence
    SILpsth = psth;

  else				     %% 3. handle textures
    [isok, fam, stat, dur, id, cmapr, cmapcB, cmapcE] = parseStimName(stim,nReps);  
    if isok
      switch dur
        case 1,
	  sTEXpsth(fam,stat,id,:) = psth;
	case 2,
	  lTEXpsth(fam,stat,id,:) = psth;
	otherwise,
	  error('%s: Texture stim %s has a broken duration.\n', mfilename, stim)
      end % switch dur
    else
      fprintf('Skipping %s\n', stim);
    end  % valid texture to analyze
  end % sorting through tags

end  % for loop on each stim name

