function [f, frequency_response] = apply_window(in, config)

fs = config.sampleRate;
fc = config.fc;
unit = 'V';

for ind = 1:size(in, 2)

  h = in(:,ind);

  if ind == 1
    [t_start,t_rise] = mataa_guess_IR_start(h,fs);
  endif
 	[hh,th] = mataa_signal_crop(h,fs,t_start-t_rise,t_start + 1/fc);
  hh = detrend(hh);
  [mag,phase,f,unit_mag] = mataa_IR_to_FR(hh,fs,[],unit);

  endFrequencyIndex = find(f > 20000, 1); % should need to do this only once, but who cares
  frequency_response(:,ind) = mag(1:endFrequencyIndex);
endfor

f = f(1:endFrequencyIndex);

endfunction
