function stepper_wait_until_position_reached()

  while ~stepper_is_position_reached()
    pause(1);
  end

endfunction
