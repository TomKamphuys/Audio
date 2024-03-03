function [s0, fs, T] = create_test_signal(config)

fs = config.sampleRate;
sig = config.testSignal;

switch (sig)

    % MLS
  case 'MLS'
    nMLS = config.MLS.nMLS;
    s0 = mataa_signal_generator ('MLS',fs,0,nMLS); % MLS of length 2^(n-1)
    fH = fL = [];
    T = 2^(nMLS-1) / fs; % length of signal


  case 'sweep'
    T = config.sweep.duration;
    fL = config.sweep.startFrequency;
    fL = max([1/T,fL]);
    fH = config.sweep.stopFrequency;
    fH = min([fs/2,fH]);
    s0 = mataa_signal_generator ('sweep',fs,T,[fL fH]); % log-sweep from fL to fH


  % Pink noise:
  case 'pinknoise'
    T = config.pinknoise.duration;
    s0 = mataa_signal_generator ('pink',fs,T); % pink noise sequence of length T


  % White noise:
  case 'whitenoise'
    s0 = mataa_signal_generator ('white',fs,T); % white noise sequence of length T

end

U0rms = config.amplitude;
s0 = s0 * U0rms/sqrt(sum(s0.^2)/length(s0)); % normalise to desired RMS level

endfunction
