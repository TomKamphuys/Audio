function grbl_wait_for_move_ready(grbl)

  grbl_send(grbl, 'G4 P0');

%  grbl_wait_for_ok(grbl);

endfunction
