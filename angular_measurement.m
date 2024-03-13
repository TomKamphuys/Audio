function angular_measurement()
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

stepper_set_current_position_as_zero();

stepper_minimize_backlash(config);

measurement_dir = 'Measurements';
directory_name = datestr(now, 30);
full_directory_name = [measurement_dir filesep directory_name];
mkdir(full_directory_name);

for ind = 1:length(measurementAngles)
  measurementAngle = measurementAngles(ind);

  file = sprintf('%s%shor%d', full_directory_name, filesep, measurementAngle);

  stepper_move_to_position(measurementAngle, config);

  [h,t,unit] = mataa_measure_IR(s0,fs,Nrepeat,0.2,loopback,calfile,'V');
  audiowrite(sprintf("%s.%s",file, 'wav'), h, config.sampleRate);

  if ind == 1
    [t_start,t_rise] = mataa_guess_IR_start(h,fs);
  endif
 	[hh,th] = mataa_signal_crop(h,fs,t_start-t_rise,t_start + 1/fc);
  hh = detrend(hh);
  [mag,phase,f,unit_mag] = mataa_IR_to_FR(h,fs,[],unit);

  comment = sprintf('hoek: %d', measurementAngle);

  mataa_export_FRD(f,mag,phase,comment,file);
  mataa_export_TMD(t, h, comment, file);

%  semilogx(f, mag); %
%	[mag,phase,f,unit_mag] = mataa_IR_to_FR (hh,fs,[],unit);

% save frd file ? function mataa_export_FRD (f,mag,phase,comment,file);

end

stepper_finish(config);



endfunction
