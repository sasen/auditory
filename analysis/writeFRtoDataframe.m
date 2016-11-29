function tsvfilename = writeFRtoDataframe(clu_fname,birdsite_nametag)
% writeFRtoDataframe() reads a matfile (from python) of a cluster's firing rates for each trial,
%    and reformats it into a tsv for importing into an R data.frame().
% tsvfilename = writeFRtoDataframe(clu_fname,birdsite_nametag)
% tsvfilename: str, tab separated values file, like "fr_unit31.txt"
% clu_fname: str, matfile like 'sptrains_unit31.mat'
% birdsite_nametag: str, directory, like B1040_3
%% TODO FIXME SS : deal with birdsites with misnamed stimuli! eg verify length in tTimes

load(fullfile('DATA',birdsite_nametag,clu_fname));
tsvfilename = fullfile('DATA',birdsite_nametag,['fr_' clu_fname(10:end-4) '.txt']);
tTimes = round(tTimes,2,'significant');  %handles funny rounding issues  %% unique(tTimes(:,3)); % 0.8, 1, 5, 6, 7
stims = cellstr(stims);  % convert char array to cell array of char vectors
fid = fopen(tsvfilename,'w');
fprintf(fid, 'fam\tstat\tID\tdur\tpre\tplay\tpost\n');

%% Go through each stimulus
stimnames = unique(stims);
for s = 1:length(stimnames)
  stim = stimnames{s};
  stim_idx = find(strcmp(stim,stims)); % trials using that stim

  %%% Create and go through tag particles
  tags = strsplit(stim,'_');
  motifnum = str2double(tags{1});    % if it's a motif, get its number.

  if isfinite(motifnum)		     %% 1. handle motifs
    fam = 'motif'; stat = 'norm'; id = motifnum;
  elseif strcmp('silence',tags{1})   %% 2. skip silence
    fam = 'silence'; stat = 'norm'; id = 0;
  else				     %% 3. handle textures
    fam  = tags{3}; stat = tags{1}; id = str2num(tags{2}(2));
  end % make sense of tags

  for n = stim_idx'  % go through trials of this stim type
    dur = tTimes(n,3);
    fprintf(fid, '%u\t%s\t%s\t%u\t%0.1f\t%0.2f\t%0.2f\t%0.2f\n',trialID(n),fam,stat,id,dur,deal(fr(n,:)));
  end  % going through trials of this stim type

end  % for loop on each stim name
fclose(fid);



%     [isok, fam, stat, dur, id, cmapr, cmapcB, cmapcE] = parseStimName(stim);  
%     if isok
%       textures(dur,fam,stat,id,:) = fr_on_norm(stim_idx);
%       %% and make a colormap-able figure for each duration      
%       switch dur
%         case 1,
% 	  txtS(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
% 	case 2,
% 	  txtL(cmapr, cmapcB:cmapcE) = fr_on_norm(stim_idx);
% 	otherwise,
% 	  error('%s: Stim %s has a broken duration.\n', mfilename, stim)
%       end % switch dur
%     else
%       fprintf('Skipping %s\n', stim);
%     end  % valid texture to analyze
