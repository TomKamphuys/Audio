function result = grbl_wait_for_ok(grbl)

  result = grbl_read(grbl);

  while (length(strfind(result, 'ok')) == 0)
    pause(0.1);
    result = grbl_read(grbl);
  end

  disp(result);

endfunction
