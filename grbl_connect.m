function grbl = grbl_connect(com_port, baudrate)

  if nargin < 2
    baudrate = 115200;
  end

  if nargin < 1
    com_port = 'COM5';
  end

  pkg load instrument-control;

  grbl = serialport(com_port, baudrate);

endfunction
