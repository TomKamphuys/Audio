function [idIn, idOut, latency] = mataa_asio_device_identification(audioDevName)

% function [idIn, idOut] = mataa_asio_device_identification(audioDevName)
%
% DESCRIPTION:
% audio device IDs on Windows change often, especially if more than on device is connected
% mataa_asio_device_identification() function ensures proper device identification in a randomly
% changing environment. This function relies on blockdevices() from LTFAT octave forge package.
%
% INPUT:
% audioDevName: Inditification string that is unique for the target audio interface. Initially
%               this string can be identified with the help of blockdevices().
%
% OUTPUT:
% idIn: input device ID
% idOut: output device ID
% latency: expected latency of audio hardware
%
% DISCLAIMER:
% This file is part of MATAA.
%
% MATAA is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% MATAA is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with MATAA; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
%
% Copyright (C) 2020 Christoph Wendel
% Contact: christophwendel@posteo.de
% Further information:

  targetAPI = "ASIO";
  audioDevList = blockdevices();
  nDev = length(audioDevList);
  devFound = zeros([1,nDev]);

  for i=1:nDev
    if( index(audioDevList(i).hostAPI, targetAPI) && index(audioDevList(i).name, audioDevName ) )
      devFound(i) = 1;
    else
      devFound(i) = 0;
    end %endif
  end %endfor

  if( ~devFound )
    error(sprintf('mataa_asio_device_identification: No audio interface found with "%s" API and "%s" on this machine.', targetAPI, audioDevName));
  else
    apiIdx = find(devFound>0);
    id = audioDevList(apiIdx).deviceID;
  end %endif

  x = max([audioDevList(apiIdx).defaultLowInputLatency audioDevList(apiIdx).defaultHighInputLatency audioDevList(apiIdx).defaultLowOutputLatency audioDevList(apiIdx).defaultHighOutputLatency ]);
  a = 10e-3;
  latency = ceil(x/a) * a;

  idIn = id; idOut = id;

end %endfunction




