function [measurementAngles, data] = angular_measurement()
% Use this script for acoustic measurements of impulse response

config = read_config();

Nrepeat = config.numberOfRepeats;
loopback = config.loopback;
measurementAngles = config.measurementAngles;
latency = config.latency;
irDuration = config.irDuration;
endIndex = irDuration*config.sampleRate;

fc=config.fc;


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

stepper_set_current_position_as_zero();

stepper_minimize_backlash(config);

measurement_dir = 'Measurements';
directory_name = datestr(now, 30);
full_directory_name = [measurement_dir filesep directory_name];
mkdir(full_directory_name);

clear data;

for ind = 1:length(measurementAngles)
  measurementAngle = measurementAngles(ind);

  file = sprintf('%s%shor%d', full_directory_name, filesep, measurementAngle);

  stepper_move_to_position(measurementAngle, config);

  [h,t,unit] = mataa_measure_IR(s0,fs,Nrepeat,latency,loopback,calfile,'V');
  hh = h(1:endIndex);

  audiowrite(sprintf("%s.%s",file, 'wav'), hh, config.sampleRate);

  data(:,ind) = hh;

end

stepper_finish(config);


endfunction
