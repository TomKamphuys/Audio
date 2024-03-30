function result = grbl_move_x(grbl, amount)

  result = grbl_send(grbl, sprintf('G0 X%f', amount));

  pause(0.1);

  grbl_wait_for_move_ready(grbl);

endfunction
