% Parameters
int: NOrders = 3;
set of int: O = 1..NOrders;

array[O] of float: req_width = [0.5, 0.7, 0.9];
array[O] of float: req_length = [1000.0, 3000.0, 2000.0];

int: NStd = 2;
set of int: S = 1..NStd;
array[S] of float: std_width = [1.0, 2.0];

int: SCALE = 10; % widths have 1 decimal, scale to integer decimeters
array[O] of int: req_w = [round(req_width[o]*SCALE) | o in O];
array[S] of int: std_w = [round(std_width[s]*SCALE) | s in S];

int: total_len = sum(o in O)(round(req_length[o])); % meters, integer already

% Variables
array[S,O] of var 0..total_len: x; % x[s,o] = length (m) of order o cut from standard roll width s

var 0..(sum(s in S)(std_w[s]) * total_len): waste_area_dm2;

% Constraints
constraint
  forall(o in O)(
    sum(s in S)(x[s,o]) = round(req_length[o])
  );

constraint
  forall(s in S, o in O)(
    std_w[s] >= req_w[o] -> true
    /\
    std_w[s] < req_w[o] -> x[s,o] = 0
  );

constraint
  waste_area_dm2 =
    sum(s in S, o in O)(
      (std_w[s] - req_w[o]) * x[s,o]
    );

% Objective
solve minimize waste_area_dm2;