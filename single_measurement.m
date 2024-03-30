% Use this script for acoustic measurements of impulse response

config = read_config();

Nrepeat = config.numberOfRepeats;
loopback = config.loopback;
measurementAngles = config.measurementAngles;
fc=100;


[s0, fs, T] = create_test_signal(config);

if loopback
	kDUT = mataa_settings('channel_DUT');
	kREF = mataa_settings('channel_REF');

	calfile = {};
	calfile{kDUT} = 'FLAT_SOUNDCARD.txt';
	calfile{kREF} = 'FLAT_SOUNDCARD.txt';
else
	calfile = 'MB_ACOUSTIC_CHAIN_DUT.txt';
end


test_signal = s0;
channels = [ mataa_settings('channel_DUT') mataa_settings('channel_REF') ]; % use DUT and REF channel
if length (channels) == 2
% dual channel output to DAC:
  test_signal = [ test_signal(:) test_signal(:) ];
end

latency = 0.5;


[out,in,t,out_unit,in_unit,X0_RMS] = mataa_measure_signal_response (test_signal,fs,latency,1,channels,calfile,'V');

[h,t,unit] = mataa_measure_IR(s0,fs,Nrepeat,latency,loopback,calfile,'V');
audiowrite('impulseResponse.wav', h, config.sampleRate);

