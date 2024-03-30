function init()

addpath(genpath(['..' filesep 'mataa'], '.git'));


pkg load ltfat;
audioDevName = 'UMC ASIO Driver';
[idIn, idOut, latency] = mataa_asio_device_identification(audioDevName);

mataa_settings('audio_IO_method', 'playrec');
mataa_settings('audio_PlayRec_OutputDeviceName', audioDevName);
mataa_settings('audio_PlayRec_InputDeviceName', audioDevName);

endfunction
