function grbl_initialize(grbl)

  grbl_send(grbl, '?');
  grbl_send(grbl, '$I');
  grbl_send(grbl, '$$');
  grbl_send(grbl, '$G');

endfunction
