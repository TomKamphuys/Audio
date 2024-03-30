function result = grbl_send(serial, cmd)

  disp(['>>> ' cmd]);
  fprintf(serial, cmd);
  pause(1);

  result = char(fread(serial));
  disp(result);

endfunction
