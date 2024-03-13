function [status, output] = stepper(options)

  [status, output] = system(sprintf("ticcmd %s", options), true);

endfunction
