function result = grbl_move(grbl, x, y, z)

  result = grbl_send(grbl, sprintf('G0 X%f Y%f Z%f', x, y, z));

  pause(0.1);

  grbl_wait_for_move_ready(grbl);

endfunction
