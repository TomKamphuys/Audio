function result = grbl_send(grbl, cmd)

  disp(['>>> ' cmd]);
  fprintf(grbl, cmd);

  result = grbl_wait_for_ok(grbl);

endfunction
