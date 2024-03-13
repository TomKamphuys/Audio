function stepper_minimize_backlash(config)

  stepper_move_to_position(-10, config);
  stepper_move_to_position(0, config);

endfunction
