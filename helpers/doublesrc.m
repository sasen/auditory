function outWav = doublesrc(audfilename)
% doublesrc doubles the sampling rate of a wav file. ("lowpass interpolation" via interp)
% you should be in same dir as the wav file. input wav file should be 20kHz. sorry.
% write new file with 40kHz sr to a folder in the same directory called 40kHz, same base filename.
% outWav = doublesrc(audfilename)

L2 = 2;        % Interpolation factor
[inWav, fs] = audioread(audfilename); % input wav and its sampling rate
outWav = interp(inWav, L2);  % "lowpass interpolation"
outfilename = ['40kHz', filesep, audfilename];
outfs = fs * L2;
assert(outfs==40000);
audiowrite(outfilename, outWav, outfs);
