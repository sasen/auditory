familyList = cell({'Applause.wav','Bubbling_water.wav','Sparrows.wav','Starlings.wav', ...
		   'Wind_whistling.wav'});
%familyList = cell({'Sparrows.wav', 'Starlings.wav','Wind_whistling.wav'});
singleOutputDir = 'allstats';  % Put all stimuli in the same output dir
longDuration = 5; % in seconds
shortDuration = 0.8; % in seconds
origDuration = 7; % in seconds
numRealizations = 3; % how many of each texture family

Duration = shortDuration;
% looping through all the texture families
for famNum = 1:length(familyList)
  origName = familyList{famNum}
  P = params_default(origName,singleOutputDir,Duration,origDuration);

  for rlz = 1:numRealizations
    oldnoise_filename = [P.output_folder 'noise_7' num2str(rlz) '_' P.orig_sound_filename];
    toolong = audioread(oldnoise_filename);
    long_fname = [P.output_folder 'noise_l' num2str(rlz) '_' P.orig_sound_filename];
    shrt_fname = [P.output_folder 'noise_s' num2str(rlz) '_' P.orig_sound_filename];
    audiowrite(long_fname, toolong(1:P.audio_sr*longDuration), P.audio_sr);
    audiowrite(shrt_fname, toolong(end-(P.audio_sr*shortDuration):end), P.audio_sr);
  end
  
end % texture families
