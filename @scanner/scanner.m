classdef scanner < handle
  properties (Access = private)
    config;
    grbl;
    current_position; % r, phi, z
    safe_cylinder; % add safety for the speaker. Don't move if the move will touch the speaker
  endproperties

  methods
    function s = scanner()
      s.config = read_config();
      s.grbl = grbl_connect();
      s.safe_cylinder = [0, 0, 0]; % dummy initial value [min height, max height, min radius]

      stepper_set_current_position_as_zero();
      s.current_position = [0, 0, 0];
    endfunction

    function disp(obj)
      disp('Seems to work...');
    endfunction

  endmethods

  methods (Access = public)
    function set_as_min_height(obj)
      obj.safe_cylinder(1) = obj.current_position(3);
    endfunction

    function set_as_max_height(obj)
      obj.safe_cylinder(2) = obj.current_position(3);
    endfunction

    function set_as_min_radius(obj)
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
      obj.safe_cylinder = [obj.safe_cylinder(1) + difference(3), obj.safe_cylinder(2) + difference(3), obj.safe_cylinder(3) + difference(1)];
      obj.current_position = zero;
    endfunction

    function move(obj, new_position)
      if (obj.check_whether_position_is_in_safe_volume(new_position))
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
      if (obj.check_whether_position_is_in_safe_volume(new_position))
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

  endmethods

endclassdef



