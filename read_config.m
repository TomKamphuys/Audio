function config = read_config()

config.sampleRate = 44100; % [Hz]
config.testSignal = 'sweep'; % {MLS, pinknoise, whitenoise, sweep}
config.amplitude = 0.5; % [V] Test signal amplitude (V-RMS)
config.numberOfRepeats = 1; % [-] an integer
config.loopback = 0; % Do you want to use loopback compensation [1/0]
config.measurementAngles = [0 10 20 30]; % [degreed] measurements angles

% Number of MLS taps n (MLS length = 2^(n-1) samples):
% config.MLS.nMLS = -1;

config.sweep.duration = 1; % [s]
config.sweep.startFrequency = 20; % [Hz]
config.sweep.stopFrequency = 20000; % [Hz]

% config.pinknoise.duration = 5; % [s]
% config.whitenoise.duration = 5; % [s]

endfunction
