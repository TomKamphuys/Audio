
pkg load ltfat;
audioDevName = 'UMC ASIO Driver';
[idIn, idOut, latency] = mataa_asio_device_identification(audioDevName);

mataa_settings('audio_IO_method', 'playrec')
mataa_settings('audio_PlayRec_OutputDeviceName', 'UMC ASIO Driver')
mataa_settings('audio_PlayRec_InputDeviceName', 'UMC ASIO Driver')
