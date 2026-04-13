% Parameters (with values embedded)
int: min_total_shifts = 10;
int: cost_X = 8;
int: cost_Y = 5;
int: balance_extra = 4;

% Variables
var 0..1000: x; % number of shifts for type X
var 0..1000: y; % number of shifts for type Y

% Constraints
constraint x + y >= min_total_shifts;
constraint x - 2*y <= balance_extra;

% Objective
solve minimize cost_X * x + cost_Y * y;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(cost_X * x + cost_Y * y), "\n"
];