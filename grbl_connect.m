function grbl = grbl_connect(com_port, baudrate)

  if nargin < 2
    baudrate = 115200;
  end

  if nargin < 1
    com_port = 'COM8';
  end

  pkg load instrument-control;

  grbl = serialport(com_port, baudrate);
  grbl.Timeout = 0.1;
  grbl_read(grbl);

  pause(2);

  grbl_send(grbl, '$1=25'); % hold position

  % set resolution ( 200 steps per 2*pi*7 mm), speed and accel
%  grbl_send(grbl, '$100=4.547');
%  grbl_send(grbl, '$101=4.547');

  % 1/16 microstepping
  grbl_send(grbl, '$100=72.752');
  grbl_send(grbl, '$101=72.752');

  grbl_send(grbl, '$110=10000');
  grbl_send(grbl, '$111=10000');

  grbl_send(grbl, '$120=100');
  grbl_send(grbl, '$121=100');


endfunction
