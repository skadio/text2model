% Parameters (with values embedded)
int: max_total_shifts = 24;
int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 10;

int: max_X = 12;
int: max_Y = 8;
int: max_Z = 6;

int: min_diff_XY = 2;   % X >= Y + 2
int: max_diff_YZ = 4;   % |Y - Z| <= 4

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y + Z <= max_total_shifts;

constraint X >= Y + min_diff_XY;

constraint abs(Y - Z) <= max_diff_YZ;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];