function result = grbl_move_z(grbl, amount)

  result = grbl_send(grbl, sprintf('G0 Z%f', amount));

  grbl_wait_for_move_ready(grbl);

endfunction
