function [base_fr_trials, txtS, txtL, snamesS, snamesL,textures] = processClusterFR(clu_fname,birdsite_nametag,nReps,PLOT_COLORMAPS,fid,dfStr_clu)
% function [base_fr_trials, txtS, txtL, snamesS, snamesL,textures] = processClusterFR(clu_fname,birdsite_nametag,nReps,PLOT_COLORMAPS,fid,dfStr_clu)
% processClusterFR computes zscored firing rates
% clu_fname: str, matfile like 'sptrains_unit31.mat'
% birdsite_nametag: str, directory, like B1040_3
% nReps: int, approx number of repetitions for each trial, eg 5 or 10. (will truncate more, and inf-pad if fewer)
% PLOT_COLORMAPS: logical 0=skip plotting, 1=plot and save FR colormaps for each cluster
% fid: int, open file handle for writing dataframe
% dfStr_clu: str (tsv), partial row of dataframe with info for this cluster
% base_fr_trials: numeric vector, silent-trial firing rates (zscore)
% txtS, txtL: 15x4*nReps numeric, short/long texture firing rates while stim is on (zscore). Very carefully structured for colormaps!
% snamesS, snamesL: stimuli names for short/long stimuli, shaped like the txtS and txtL matrices
% textures: dur,fam,stat,id,reps
%% TODO FIXME SS : deal with birdsites with misnamed stimuli! eg verify length in tTimes
%% TODO FIXME SS : pass nExemp, nFams, nStats as args

load(fullfile('DATA',birdsite_nametag,clu_fname));
tTimes = round(tTimes,2,'significant');   %% unique(tTimes(:,3)); % 0.8, 1, 5, 6, 7
stims = cellstr(stims);  % convert char array to cell array of char vectors

%% zscore firing rates (by all cluster responses)   %% TODO should I zscore by the trials i'm actually analyzing? THINK!
zfr_on = zscore(fr(:,2)); % fr rows: [pre on post]

%% get baseline stats  %% defunct!!
baselineStim = 'silence_40k_5s';
base_idx = find(strcmp(baselineStim,stims));  % baseline trial index
base_fr_trials = zfr_on(base_idx);	% grab firing rate of those trials

%% data structures for FR on each texture trial
txtS = inf(3*5,4*nReps); % sorry FIXME
txtL = inf(3*5,4*nReps); % sorry FIXME
textures = NaN(2,5,4,3,nReps);

%% Go through each stimulus
stimnames = unique(stims);
for s = 1:length(stimnames)
  stim = stimnames{s};
  stim_idx = find(strcmp(stim,stims)); % trials using that stim
  fr_data = zfr_on(stim_idx); % firing rates of these trials
  nTrials = numel(stim_idx);

  %%% Create and go through tag particles
  tags = strsplit(stim,'_');
  motifnum = str2double(tags{1});    % if it's a motif, get its number.
  if isfinite(motifnum)		     %% 1. handle motifs
    motifs(:,motifnum) = fr_data;
  elseif strcmp('silence',tags{1})   %% 2. skip silence
    % pass
  else				     %% 3. handle textures
    [isok, fam, stat, dur, id, cmapr, cmapcB, cmapcE, dfStr_stim] = parseStimName(stim,nReps);  

    %% print to dataframe
    for trNum = 1:nTrials
      fprintf(fid, '%s%s%d\t%f\n', dfStr_clu, dfStr_stim, trNum, fr_data(trNum));  
    end   % going through trials

    if isok    %%% these are the ones that we have for most subjects
      %% first, deal with missing or too much data!
      if nTrials ~= nReps
        fprintf('%s: Warning, stim %s had %d trials rather than %d\n',mfilename,stim,nTrials,nReps);
        if nTrials < nReps	  
          fr_data = [reshape(fr_data,1,nTrials) nan(1,nReps-nTrials)];  % pad with infinities
        else
          fr_data = fr_data(1:nReps);  % take the first nReps number of trials, ignore the rest
	end
      end   % if nTrials isn't the same as nReps
      textures(dur,fam,stat,id,:) = fr_data;
      %% and make a colormap-able figure for each duration      
      switch dur
        case 1,
	  txtS(cmapr, cmapcB:cmapcE) = fr_data;
	  snamesS(cmapr,stat) = stimnames(s);  % cell array of stim names shaped like these matrices
	case 2,
	  txtL(cmapr, cmapcB:cmapcE) = fr_data;
	  snamesL(cmapr,stat) = stimnames(s);  % cell array of stim names shaped like these matrices
	otherwise,
	  error('%s: Stim %s has a broken duration.\n', mfilename, stim)
      end % switch dur
    else
    end  % stim that we have in lots of subjects
  end % sorting through tags
end  % for loop on each stim name

if PLOT_COLORMAPS  % optional make & save figures
%% TODO the infs are currently NaNs, so these plots will not work.
  figure(1); clf; imagesc([txtS; inf(1,4*nReps); txtL])
  title(sprintf('Cluster %s Texture FR (zscore)',clu_fname(14:end-4)))
  xlabel(['Noise                     Marginals                    Full Stats                      Originals'])
  ylabel(['Wind   Star   Spar   Bub   App       Wind  Star    Spar    Bub     App'])
  fig_fname = fullfile('analysis','figures',birdsite_nametag, sprintf('ztxtFR_%s.png',clu_fname(14:end-4)) );
  saveas(gcf, fig_fname)
end     % if plotting flag