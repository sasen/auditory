function [base_fr_trials, txtS, txtL] = processClusterFR(clu_fname,birdsite_nametag,nReps)
%function [base_fr_trials, txtS, txtL] = processClusterFR(clu_fname,birdsite_nametag,nReps)
% processClusterFR computes FRs
% [base_fr_trials, txtS, txtL, motifs] = processClusterFR(clu_fname, birdsite_nametag)
% clu_fname: str, matfile like 'sptrains_unit31.mat'
% birdsite_nametag: str, directory, like B1040_3
% base_fr_trials: silence
% txtS, txtL: short, long textures
% motifs: motifs
%% TODO FIXME SS : deal with birdsites with misnamed stimuli! eg verify length in tTimes

baselineStim = 'silence_40k_5s';  % name of stimulus, will be normalizing by this

load(fullfile('DATA',birdsite_nametag,clu_fname));
tTimes = round(tTimes,2,'significant');   %% unique(tTimes(:,3)); % 0.8, 1, 5, 6, 7
stims = cellstr(stims);  % convert char array to cell array of char vectors

%% get baseline stats
base_idx = find(strcmp(baselineStim,stims));  % baseline trial index
base_fr_trials = fr(base_idx,:);	% grab firing rate of those trials
base_fr_on = mean(base_fr_trials(:,2));  % fr rows: [pre on post]

fr_on_norm = fr(:,2) / base_fr_on;  % normalized firing rate while stim is on, for each trial
txtS = inf(3*5,4*nReps); % sorry FIXME
txtL = inf(3*5,4*nReps); % sorry FIXME

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
      textures(dur,fam,stat,id,:) = fr_on_norm(stim_idx);
      %% and make a colormap-able figure for each duration      
      switch dur
        case 1,
	  txtS(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
	case 2,
	  txtL(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
	otherwise,
	  error('%s: Stim %s has a broken duration.\n', mfilename, stim)
      end % switch dur
    else
      fprintf('Skipping %s\n', stim);
    end  % valid texture to analyze
  end % sorting through tags

end  % for loop on each stim name

scalemin = 0.1*min(fr_on_norm(find(fr_on_norm)));
scalemax = 1.5*max(fr_on_norm);
%figure(1); imagesc(motifs, [scalemin scalemax])
figure(2); clf; imagesc([txtS; inf(1,4*nReps); txtL], [scalemin scalemax])
title(sprintf('Cluster %s Texture FR',clu_fname(14:end-4)))
xlabel(['Noise                     Marginals                    Full Stats                      Originals'])
ylabel(['Wind   Star   Spar   Bub   App       Wind  Star    Spar    Bub     App'])
fig_fname = fullfile('analysis','figures',birdsite_nametag, sprintf('txtFR_%s.png',clu_fname(14:end-4)) );
saveas(gcf, fig_fname)

% subplot(3,1,1); imshow(motifs,[scalemin,scalemax])
% subplot(3,1,2); imshow(txtS,[scalemin,scalemax])
% subplot(3,1,3); imshow(txtL,[scalemin,scalemax])
