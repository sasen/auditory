function [isok, fam, stat, dur, id, cmaprow, cmapcolBeg, cmapcolEnd] = parseStimName(stim)
% parseStimName helps figure out where in the results table to put this stimulus type
% function [isok, fam, stat, dur, id] = parseStimName(stim)
% isok = bool, true if okay to analyze, false o.w.
% stim = str, name of a texture stimulus
% fam = int, categorical texture family
% stat = int, categorical statistical model
% dur = int, categorical duration
% id = int, categorical texture exemplar

nReps = 10;   % sorry. FIXME 
families = {'Applause','BubWater','Sparrows','Starlings','Wind'};     % 'longsong', 'flock1020'
stats = {'noise','marg','full','norm'};   % 'orig'
durations = {'s','l'}; % '7'     % this is known to be wrong in many cases!
exemplars = {'1','2','3'};   % '4'

tags = strsplit(stim,'_');
assert(numel(tags)==3, '%s: stim names require 3 tags, unlike this one... %s', mfilename, stim)
assert(numel(tags{2})==2, '%s: middle tag needs 2 characters, unlike this one... %s', mfilename, tags{2})

fam  = find(strcmp(tags{3},families));
stat = find(strcmp(tags{1},stats));
dur  = find(strcmp(tags{2}(1),durations));
id   = find(strcmp(tags{2}(2),exemplars));

if isempty(fam) || isempty(stat) || isempty(dur) || isempty(id)
  isok = false;
  cmaprow = NaN; cmapcolBeg = NaN; cmapcolEnd = NaN;
else
  isok = true;
  cmaprow = sub2ind( [numel(exemplars),numel(families)], id, fam );
  cmapcolBeg = sub2ind( [nReps,numel(stats)], 1, stat );
  cmapcolEnd = sub2ind( [nReps,numel(stats)], nReps, stat );
end