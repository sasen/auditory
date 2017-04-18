function [base_fr_trials, txtS, txtL,ztxtS,ztxtL] = processClusterFR(clu_fname,birdsite_nametag,nReps)
%function [base_fr_trials, txtS, txtL,ztxtS,ztxtL] = processClusterFR(clu_fname,birdsite_nametag,nReps)
% processClusterFR computes FRs 2 ways
% clu_fname: str, matfile like 'sptrains_unit31.mat'
% birdsite_nametag: str, directory, like B1040_3
% nReps: int, number of repetitions for each trial, eg 5 or 10.
% base_fr_trials: silence
% txtS, txtL: short, long texture firing rates while stim is on (baseline normalized n-fold change)
% ztxtS, ztxtL: short, long texture firing rates while stim is on (raw FR, zscored)
%% TODO FIXME SS : deal with birdsites with misnamed stimuli! eg verify length in tTimes

baselineStim = 'silence_40k_5s';  % name of stimulus, will be normalizing by this

load(fullfile('DATA',birdsite_nametag,clu_fname));
tTimes = round(tTimes,2,'significant');   %% unique(tTimes(:,3)); % 0.8, 1, 5, 6, 7
stims = cellstr(stims);  % convert char array to cell array of char vectors

%%%% zscore firing rates (by all cluster responses)
zfr_on = zscore(fr(:,2)); % fr rows: [pre on post]

%%%% baseline-normalize firing rates (not zscored! raw FR) to obtain n-fold change in raw FR vs silence stimulus
%% get baseline stats
base_idx = find(strcmp(baselineStim,stims));  % baseline trial index
base_fr_trials = fr(base_idx,:);	% grab firing rate of those trials
base_fr_on = mean(base_fr_trials(:,2));  % fr rows: [pre on post]
fr_on_norm = fr(:,2) / base_fr_on;  % normalized firing rate while stim is on, for each trial

%%%% data structures for both baseline normalized and zscored FR on each texture trial
txtS = inf(3*5,4*nReps); % sorry FIXME
txtL = inf(3*5,4*nReps); % sorry FIXME
ztxtS = inf(3*5,4*nReps); % sorry FIXME
ztxtL = inf(3*5,4*nReps); % sorry FIXME

%% Go through each stimulus
stimnames = unique(stims);
for s = 1:length(stimnames)
  stim = stimnames{s};
  stim_idx = find(strcmp(stim,stims)); % trials using that stim

  %%% Create and go through tag particles
  tags = strsplit(stim,'_');
  motifnum = str2double(tags{1});    % if it's a motif, get its number.
  if isfinite(motifnum)		     %% 1. handle motifs
    motifs(:,motifnum) = fr_on_norm(stim_idx);
  elseif strcmp('silence',tags{1})   %% 2. skip silence
    % pass
  else				     %% 3. handle textures
    [isok, fam, stat, dur, id, cmapr, cmapcB, cmapcE] = parseStimName(stim,nReps);  
    if isok
%      textures(dur,fam,stat,id,:) = fr_on_norm(stim_idx);
%      ztextures(dur,fam,stat,id,:) = zfr_on(stim_idx);
      %% and make a colormap-able figure for each duration      
      switch dur
        case 1,
	  txtS(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
	  ztxtS(cmapr, cmapcB:cmapcE) = zfr_on(stim_idx);
	case 2,
	  txtL(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
	  ztxtL(cmapr, cmapcB:cmapcE) = zfr_on(stim_idx);
	otherwise,
	  error('%s: Stim %s has a broken duration.\n', mfilename, stim)
      end % switch dur
    else
%      fprintf('Skipping %s\n', stim);
    end  % valid texture to analyze
  end % sorting through tags

end  % for loop on each stim name

scalemin = 0.1*min(fr_on_norm(find(fr_on_norm)));
scalemax = 1.5*max(fr_on_norm);
figure(1); clf; imagesc([ztxtS; inf(1,4*nReps); ztxtL])
title(sprintf('Cluster %s Texture FR (zscore)',clu_fname(14:end-4)))
xlabel(['Noise                     Marginals                    Full Stats                      Originals'])
ylabel(['Wind   Star   Spar   Bub   App       Wind  Star    Spar    Bub     App'])
fig_fname = fullfile('analysis','figures',birdsite_nametag, sprintf('ztxtFR_%s.png',clu_fname(14:end-4)) );
saveas(gcf, fig_fname)
figure(2); clf; imagesc([txtS; inf(1,4*nReps); txtL], [scalemin scalemax])
title(sprintf('Cluster %s Texture FR n-fold change',clu_fname(14:end-4)))
xlabel(['Noise                     Marginals                    Full Stats                      Originals'])
ylabel(['Wind   Star   Spar   Bub   App       Wind  Star    Spar    Bub     App'])
fig_fname = fullfile('analysis','figures',birdsite_nametag, sprintf('txtFR_%s.png',clu_fname(14:end-4)) );
saveas(gcf, fig_fname)

% subplot(3,1,1); imshow(motifs,[scalemin,scalemax])
% subplot(3,1,2); imshow(txtS,[scalemin,scalemax])
% subplot(3,1,3); imshow(txtL,[scalemin,scalemax])
