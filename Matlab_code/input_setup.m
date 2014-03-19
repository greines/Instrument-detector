function input = input_setup()
% This function returns a vector containing one channel of the input wav
% file chosen with the GUI browser. It also informs about the sampling
% frequency and the bit depth of the input file.

wav_file = uigetfile('*.wav');

[input,Fs,nBits] = wavread(wav_file);
input = input(:,1)';
input = input/max(abs(input)); %normalization step

fprintf('INFO: the input signal is sampled at %d Hz\n',Fs);
fprintf('INFO: the wav file is encoded with %d bits\n',nBits);

