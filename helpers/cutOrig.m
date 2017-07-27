basename = 'Bubbling_water.wav';
origFname = '/Users/sasen/Dropbox/ucsd/projects/auditory/expts/audio/STIMULI/bubwater2/norm_Bubbling_water.wav';

%origFname = ['/Users/sasen/Dropbox/ucsd/projects/auditory/athena/40kHz/norm5s_' basename];
%origFname = '/Users/sasen/Dropbox/ucsd/projects/auditory/athena/not_now/norm_Applause.wav';

shortDur = 0.8;
[toolong,sr] = audioread(origFname);
assert(sr==40000);

fname1 = [P.output_folder 'norm_s1_' basename];
fname2 = [P.output_folder 'norm_s2_' basename];
fname3 = [P.output_folder 'norm_s3_' basename];

skip_amt = sr*shortDur;
mid = length(toolong)/2;

audiowrite(fname1, toolong(skip_amt+1 : skip_amt+sr*shortDur), sr);
audiowrite(fname2, toolong(mid-(sr*shortDur/2) : mid+(sr*shortDur/2)), sr);
audiowrite(fname3, toolong(end-(skip_amt*2) : end-skip_amt), sr);
