function stepper_set_current_position_as_zero()

[status, output] = system(sprintf("ticcmd --halt-and-set-position 0"), true);
[status, output] = system(sprintf("ticcmd --resume"), true);

endfunction
