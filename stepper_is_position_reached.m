function out = stepper_is_position_reached()

  [status, output] = stepper('-s');
  splitstring = strsplit(output, '\n');
  requested = str2num(splitstring{21}(30:end));
  actual = str2num(splitstring{22}(30:end));

  out = actual == requested;

endfunction
