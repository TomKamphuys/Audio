function result = grbl_move_y(grbl, amount)

  result = grbl_send(grbl, sprintf('G0 Y%f', amount));

  grbl_wait_for_move_ready(grbl);

endfunction
