function angular_measurement()
% Use this script for acoustic measurements of impulse response

config = read_config();

Nrepeat = config.numberOfRepeats;
loopback = config.loopback;
measurementAngles = config.measurementAngles;


[s0, fs, T] = create_test_signal(config);

if loopback
	kDUT = mataa_settings('channel_DUT');
	kREF = mataa_settings('channel_REF');

	calfile = {};
	calfile{kDUT} = 'MB_ACOUSTIC_CHAIN_DUT.txt';
	calfile{kREF} = 'MB_ACOUSTIC_CHAIN_REF.txt';


else
	calfile = 'MB_ACOUSTIC_CHAIN_DUT.txt';
end



for ind = 1:length(measurementAngles)
  measurementAngle = measurementAngles(ind)*20;

  [status, output] = system(sprintf("ticcmd --resume --position-relative %d", measurementAngle), true);
  pause(2);

  player = audioplayer(s0, fs, 24);
  playblocking(player);

% [h,t,unit] = mataa_measure_IR(s0,fs,Nrepeat,0.2,loopback,calfile,'V');
%  plot(t, h); %
%	[mag,phase,f,unit_mag] = mataa_IR_to_FR (hh,fs,[],unit);

% save frd file ? function mataa_export_FRD (f,mag,phase,comment,file);

end

endfunction
