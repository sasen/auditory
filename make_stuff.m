% cell array of orig tracks names (of 7s orig files) %#### currently analyzing 7s, generating 5s or 0.8s.
% verify sr
% analyze once. 
% - write normlzd
% - write 3 long spec matched noise, 3 short spec matched noise
% - write one short marginals
% - save full stats
% - save filters, subbands, envs
% [NEED: 2s/3l marg; 3s/3l full; norm 7->5/.8/.8, 2x 5, 1x .8]  [done: ? norm, 6 noise, 1 short marg]
% - (new P, reload; write marg) x2s, x3l
% - (new P, reload; write full) x3s, x3l
% - measure stats of literally everything
% - check normalization
% [NEED: stupid originals]

% cell array of orig tracks names (of 7s orig files) %#### currently analyzing 7s, generating 5s or 0.8s.
familyList = cell({'Applause.wav','Bubbling_water.wav','Sparrows.wav','Starlings.wav','Wind_whistling.wav'});
%familyList = cell({'Sparrows.wav', 'Starlings.wav','Wind_whistling.wav'});
singleOutputDir = 'allstats';  % Put all stimuli in the same output dir
longDuration = 5; % in seconds
shortDuration = 0.8; % in seconds
origDuration = 7; % in seconds
numRealizations = 3; % how many of each texture family

Duration = shortDuration;
length_token = 'l';
% looping through all the texture families
for famNum = 1:length(familyList)
  origName = familyList{famNum}
  P = params_default(origName,singleOutputDir,Duration,origDuration);
  % verify sampling rate, and other parameters
  P.audio_sr = 40000;
  P.env_sr = 400;
  P.display_figures = 0;
  P.iteration_snapshots = [];
  %%%%%% TODO verify constraints are what I want
  %%%
  %%%%
%   P.constraint_set.env_C = 0;
%   P.constraint_set.mod_pow = 0;
%   P.constraint_set.mod_C1 = 0;
%   P.constraint_set.mod_C2 = 0;
  format_filename;
  new_filename_base = new_filename;

  orig_sound = format_orig_sound(P);
%   % write 3 long spec matched noise
%   %% ARGH currently writing 7s long clips. :-(
%   %% It's inefficient to redo the FFT for every realization
%   for rlz = 1:numRealizations
%     noise = spectrally_matched_noise(orig_sound);
%     % needs to say "long" in filename.
%     noisefname = [P.output_folder 'noise_7' num2str(rlz) '_' P.orig_sound_filename];
%     audiowrite(noisefname, noise, P.audio_sr);
%   end
  P.write_spec_match_noise = 0; % just did that

% analyze once. 
% - save full stats
% - save filters, subbands, envs
[target_S, store_filename] = prep_synthesis(P); 
% - write normlzd
% P.write_norm_orig = 1;
%%%%% TODO save stats for stimuli! (or maybe do this separately?)

% - (new P, reload; write marg) x2s
P.write_norm_orig = 0;  %% TODO write_norm_orig!
for rlz = 1:numRealizations
  P.desired_filename = ['full_' length_token num2str(rlz) '_' new_filename_base];
  [~, synth_S] = sasen_synth(P,store_filename);
end % looping through marginals of this length


% P.constraint_set.env_C = 1;
% P.constraint_set.mod_pow = 1;
% P.constraint_set.mod_C1 = 1;
% format_filename;
% new_filename_base = new_filename;
% for rlz = 1:numRealizations
%   P.desired_filename = ['full_' length_token num2str(rlz) '_' new_filename_base];
%   [~, synth_S] = sasen_synth(P,store_filename);
% end % looping through full stats of this length

end % looping through all the texture families








% P = params_default('Bubbling_water.wav','bubwater',0.8);
% orig_sound = format_orig_sound(P);
% measurement_win = set_measurement_window(length(orig_sound),P.measurement_windowing,P);
% target_S = measure_texture_stats(orig_sound,P,measurement_win);
% edited_S = edit_measured_stats(target_S,P);
% [orig_subbands,orig_subband_envs] = generate_subbands_and_envs(orig_sound, P.audio_sr, ...
%         P.env_sr, P.N_audio_channels, P.low_audio_f, P.hi_audio_f, P.lin_or_log_filters, ...
%         P.use_more_audio_filters,P.compression_option,P.comp_exponent,P.log_constant);
% format_filename;
%[target_S, store_filename] = prep_synthesis(P);

%[synth_sound, sr] = audioread([P.output_folder new_filename '.wav']);
%noise = spectrally_matched_noise(synth_sound);
%audiowrite([P.output_folder 'sm_noise_' P.orig_sound_filename],noise,sr);
%final_S = measure_texture_stats(synth_sound,P);
%save([P.output_folder new_filename '_store.mat'],'final_S','target_S','orig_subbands','orig_subband_envs','P');