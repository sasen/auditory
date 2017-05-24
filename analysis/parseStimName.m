function [isok, fam, stat, dur, id, cmaprow, cmapcolBeg, cmapcolEnd, stim_df_string] = parseStimName(stim,nReps)
% parseStimName helps figure out where in the results table to put this stimulus type
% function [isok, fam, stat, dur, id] = parseStimName(stim,nReps)
% nReps = int, number of repetitions (not relevant for dataframe creation)
% isok = bool, true if okay to analyze, false o.w.
% stim = str, name of a texture stimulus
% fam = int, categorical texture family
% stat = int, categorical statistical model
% dur = int, categorical duration
% id = int, categorical texture exemplar
% stim_df_string = string, part of dataframe row for trials of this stimulus

families = {'Applause','BubWater','Sparrows','Starlings','Wind', 'Longsong', 'Flock1020'};
stats = {'noise','marg','full','norm'};   % 'orig'
durations = {'s','l','7'};   % this is known to be wrong in many cases!
exemplars = {'1','2','3','4'};
maxFam = 5; maxStat=4; maxDur=2; maxID=3;  % for colormap stuff

tags = strsplit(stim,'_');
if numel(tags)~=3 || numel(tags{2}) ~=2
  clear tags;
  fprintf(1,'This stimname either lacks 3 tags or 2-char middle tag: %s\n',stim);
  tags{1} = input('Enter stat (noise,marg,full,norm):', 's');
  tags{2} = input('Enter middle tag (s,l,7)+(1,2,3):', 's');
  tags{3} = input('Enter family (Applause,BubWater,Sparrows,Starlings,Wind,Longsong,Flock1020):', 's');
  stim = strjoin(tags,'_');
end
assert(numel(tags)==3, '%s: stim names require 3 tags, unlike this one... %s', mfilename, stim)
assert(numel(tags{2})==2, '%s: middle tag needs 2 characters, unlike this one... %s', mfilename, tags{2})


fam  = find(strcmp(tags{3},families));
stat = find(strcmp(tags{1},stats));
dur  = find(strcmp(tags{2}(1),durations));
id   = find(strcmp(tags{2}(2),exemplars));

isok = false;
cmaprow = NaN; cmapcolBeg = NaN; cmapcolEnd = NaN;
if isempty(fam) || isempty(stat) || isempty(dur) || isempty(id)
  fprintf(1,'Skipping %s\n', stim);
  stim_df_string = [];
else
  stim_df_string = sprintf('%s\t%s\t%s\t%s\t', stim, stats{stat}, durations{dur}, families{fam});  % make dataframe row
  %% for most common stimuli / colormap figures
  if (fam <= maxFam) && (stat <= maxStat) && (dur <= maxDur) && (id <= maxID)
    isok = true;
    cmaprow = sub2ind( [maxID, maxFam], id, fam );
    cmapcolBeg = sub2ind( [nReps,maxStat], 1, stat );
    cmapcolEnd = sub2ind( [nReps,maxStat], nReps, stat );
  end  % common stim
end

