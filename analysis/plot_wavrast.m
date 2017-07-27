%% B1040_3ts
%% clu 18
%% orig App_s4 vs Str_s2
load('DATA/B1040_3ts/sptrains_unit18.mat');
[aos4, fs] = audioread('audio/STIMULI/B1040/norm_s4_Applause.wav');
[tos2, fs] = audioread('audio/STIMULI/B1040/norm_s2_Starlings.wav');

figure
plot([1:numel(aos4)]/fs,aos4); hold on
for tnum = 1301:1309  %% maybe should really be 1310
  ras=rasters{1,tnum};stem(ras,0.05*ones(size(ras)))
end % for these app trials 
axis([0 .8 -0.2 0.2])
%% then I stretched, changed the color of the audio to light grey and increased font size to 12 before saving


figure
plot([1:numel(tos2)]/fs,tos2); hold on
for tnum = 1231:1239  %% maybe should really be 1240
  ras=rasters{1,tnum};stem(ras,0.05*ones(size(ras)))
end % for these trials 
axis([0 .8 -0.2 0.2])
%% same modifications

figure
[tfs1, fs] = audioread('audio/STIMULI/B1040/full_s1_Starlings_10111010110.wav');
[tfs2, fs] = audioread('audio/STIMULI/B1040/full_s2_Starlings_10111010110.wav');
[tfs3, fs] = audioread('audio/STIMULI/B1040/full_s3_Starlings_10111010110.wav');
subplot(3,1,1),plot([1:numel(tfs1)]/fs,tfs1);
subplot(3,1,2),plot([1:numel(tfs2)]/fs,tfs2);
subplot(3,1,3),plot([1:numel(tfs3)]/fs,tfs3);

subplot(3,1,1), hold on
for tnum = 201:209
  ras=rasters{1,tnum};stem(ras,0.05*ones(size(ras)))
end % for these trials 
axis([0 .8 -0.2 0.2])

subplot(3,1,2), hold on
for tnum = 251:259
  ras=rasters{1,tnum};stem(ras,0.05*ones(size(ras)))
end % for these trials 
axis([0 .8 -0.2 0.2])

subplot(3,1,3), hold on
for tnum = 301:309
  ras=rasters{1,tnum};stem(ras,0.05*ones(size(ras)))
end % for these trials 
axis([0 .8 -0.2 0.2])
