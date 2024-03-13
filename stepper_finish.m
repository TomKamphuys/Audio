function stepper_finish(config)
  stepper_move_to_position(0, config);

  stepper_wait_until_position_reached();

  [status, output] = stepper("--deenergize");
endfunction
