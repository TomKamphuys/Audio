classdef scanner < handle
  properties (Access = private)
    config;
    grbl;
    current_position; % r, phi, z
    safe_cylinder; % add safety for the speaker. Don't move if the move will touch the speaker
    limits; % outer limits
    grid;
    point_number;
  endproperties

  methods
    function s = scanner()
      s.config = read_config();
      s.grbl = grbl_connect();
      s.safe_cylinder = [0, 0, 0]; % dummy initial value [min height, max height, min radius]
      s.limits = [-2000, 2000, 2000]; % dummy initial value [min height, max height, max radius]
      s.grid = [];
      s.point_number = 0;

      stepper_set_current_position_as_zero();
      s.current_position = [0, 0, 0];
    endfunction

    function disp(obj)
      disp('Seems to work...');
    endfunction

  endmethods

  methods (Access = public)


    function reset_gridpoint(obj)
      obj.point_number = 0;
    endfunction

    function set_limits(obj, limits)
      obj.limits = limits;
    endfunction

    function set_safe_cylinder(obj, safe_cylinder)
      obj.safe_cylinder = safe_cylinder;
    endfunction

    function move_to_next_gridpoint(obj)
      obj.point_number = obj.point_number + 1;
      new_position = obj.grid(:, obj.point_number)
      obj.unchecked_move(new_position);
    endfunction

    function set_grid(obj, grid)
      reset = false;
      for ind = 1:size(grid, 2)
        new_position = grid(:,ind);
        if (obj.check_whether_position_is_in_safe_volume(new_position) || obj.check_whether_position_is_out_of_limits(new_position))
          reset = true;
          break;
        end
      end

      value = grid(1,:) + 1000*grid(3,:) + 1000000*grid(2,:);
      [~, I] = sort(value);
      sorted_grid = grid(:,I);
      obj.grid = sorted_grid;

      if (reset)
        obj.grid = []; % grid not set.
      endif
    end

    function show_grid(obj)
      figure(1)
      [x, y, z] = cyl2cart(obj.grid(1,:), obj.grid(2,:)/180*pi, obj.grid(3,:));
      ind = obj.point_number;

      scatter3(x(1:ind), y(1:ind), z(1:ind), 5, 'filled', 'r');
      hold on
      scatter3(x(ind+1:end), y(ind+1:end), z(ind+1:end), 2, 'filled', 'k');
      hold off
      axis vis3d;
    endfunction

    function set_outer_min_height(obj)
      obj.limits(1) = obj.current_position(3);
    end

    function set_outer_max_height(obj)
      obj.limits(2) = obj.current_position(3);
    end

    function set_outer_max_radius(obj)
      obj.limits(3) = obj.current_position(1);
    end

    function set_inner_min_height(obj)
      obj.safe_cylinder(1) = obj.current_position(3);
    endfunction

    function set_inner_max_height(obj)
      obj.safe_cylinder(2) = obj.current_position(3);
    endfunction

    function set_inner_min_radius(obj)
      obj.safe_cylinder(3) = obj.current_position(1);
    endfunction

    function move_up(obj, amount)
      obj.relative_move([0, 0, amount])
      obj.show_position();
    endfunction

    function move_down(obj, amount)
      obj.move_up(-amount);
    endfunction

    function move_in(obj, amount)
      obj.relative_move([-amount, 0, 0]);
      obj.show_position();
    endfunction

    function move_out(obj, amount)
      obj.move_in(-amount);
    endfunction

    function move_clockwise(obj, amount)
      new_position = obj.current_position + [0, -amount, 0];
      stepper_move_to_position(new_position(2), obj.config);
      obj.current_position = new_position;
      obj.show_position();
    endfunction

    function move_counterclockwise(obj, amount)
      obj.move_clockwise(-amount);
    endfunction

    function set_as_zero(obj)
      stepper_set_current_position_as_zero();
      grbl_send(obj.grbl, 'G92 X0 Y0');
      grbl_send(obj.grbl, '$10=0');

      zero = [0, 0, 0];

      difference = zero - obj.current_position;
      obj.limits = [obj.limits(1) + difference(3), obj.limits(2) + difference(3), obj.limits(3) + difference(1)];
      obj.safe_cylinder = [obj.safe_cylinder(1) + difference(3), obj.safe_cylinder(2) + difference(3), obj.safe_cylinder(3) + difference(1)];
      obj.current_position = zero;
    endfunction

    function move(obj, new_position)
      if (obj.check_whether_position_is_in_safe_volume(new_position) || obj.check_whether_position_is_out_of_limits(new_position))
        return;
      end

      intermediate_position = obj.current_position;

      % move in/out (radially)
      intermediate_position(1) = new_position(1);
      obj.checked_move(intermediate_position);

      % rotate
      intermediate_position(2) = new_position(2);
      obj.checked_move(intermediate_position);

      % move up/down
      intermediate_position(3) = new_position(3);
      obj.checked_move(intermediate_position);
    endfunction

    function home(obj)
      move(obj, [0, 0, 0]);
    endfunction

    function show_position(obj)
      disp(obj.current_position);
      disp(obj.safe_cylinder);
    endfunction

    function clean_up(obj)
      obj.home();
      clear obj.grbl;
    endfunction

  endmethods

  methods (Access = private)
    function checked_move(obj, new_position)
      if (obj.check_whether_position_is_in_safe_volume(new_position) || obj.check_whether_position_is_out_of_limits(new_position))
        return;
      end

      % move radially (in/out)
      grbl_move(obj.grbl, -new_position(3), obj.current_position(1), 0);

      % rotate
      stepper_move_to_position(new_position(2), obj.config);

      % move up/down
      grbl_move(obj.grbl, -new_position(3), new_position(1), 0);

      obj.current_position = new_position;
    endfunction

    function unchecked_move(obj, new_position)
      grbl_move(obj.grbl, -new_position(3), new_position(1), 0);

      % rotate
      stepper_move_to_position(new_position(2), obj.config);

      obj.current_position = new_position;
    endfunction

    function relative_move(obj, vector)
      % N.B. moving up needs negative direction for grbl
      new_position = obj.current_position + vector;
      obj.move(new_position);
    endfunction

    function value = check_whether_position_is_in_safe_volume(obj, position)
      if (position(3) > obj.safe_cylinder(1) && position(3) < obj.safe_cylinder(2) && position(1) < obj.safe_cylinder(3))
        disp('WARNING: Youre trying to move into the safe cylinder');
        disp(position);
        disp(obj.safe_cylinder);
        value = true;
      else
        value = false;
      endif
    endfunction

    function value = check_whether_position_is_out_of_limits(obj, position)
      if (position(3) < obj.limits(1) || position(3) > obj.limits(2) || position(1) > obj.limits(3))
        disp('WARNING: Youre trying to move outside the limits');
        disp(position);
        disp(obj.limits);
        value = true;
      else
        value = false;
      endif
    end

  endmethods

endclassdef



