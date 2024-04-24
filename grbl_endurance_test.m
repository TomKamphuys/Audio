function grbl_endurance_test(grbl, n)

  amplitude = 20;

  for ind = 1:n
    x = 2*amplitude*(rand(1)-0.5);
    y = 2*amplitude*(rand(1)-0.5);
    z = 2*amplitude*(rand(1)-0.5);
    grbl_move(grbl, x, y, z);
  endfor

endfunction
