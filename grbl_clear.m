function grbl_clear(grbl, display)

  result = '1';

  while (length(result) ~= 0)
    result = char(fread(grbl));

    if (display)
      disp(result);
    end
    pause(0.1);

  end

end
