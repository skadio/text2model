% Parameters (with values embedded)
int: max_X1_X2 = 1000;
int: min_2X1_X3 = 800;
int: max_X2_3X4 = 600;
int: min_X1_minus_halfX4 = 200;

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Variables
var 0..1000: X1;
var 0..1000: X2;
var 0..800: X3;
var 0..200: X4;   % from X2 + 3*X4 <= 600 and X2 >= 0 => X4 <= 200

% Constraints
constraint X1 + X2 <= max_X1_X2;
constraint 2 * X1 + X3 >= min_2X1_X3;
constraint X2 + 3 * X4 <= max_X2_3X4;

% X1 - 0.5*X4 >= 200  <=>  2*X1 - X4 >= 400 (keeps everything integral)
constraint 2 * X1 - X4 >= 2 * min_X1_minus_halfX4;

% Objective
var int: total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;
solve minimize total_cost;