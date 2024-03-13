function stepper_move_to_position(measurementAngle, config)

  [status, output] = stepper("--resume");
  [status, output] = stepper(sprintf("--position %d", stepper_position(measurementAngle, config.stepsPerDegree)));

  stepper_wait_until_position_reached();

  [status, output] = stepper("--deenergize");
endfunction
