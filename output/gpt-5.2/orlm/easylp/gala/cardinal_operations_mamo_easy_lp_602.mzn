% Resource allocation / operating cost minimization for 4 departments
% All data embedded as requested.

int: max_x1x2 = 1000;
int: min_service = 500;
int: balance_limit = 200;
int: x4_more_than_x2 = 150;

% Costs per unit
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Decision variables (whole-number allocations)
% Bounds: derived from constraints to keep the model finite.
var 0..500: x1;                         % from 2*x1 + 3*x2 >= 500 and x2>=0
var 0..1000: x2;                        % from x1 + x2 <= 1000 and x1>=0
var 0..700: x3;                         % x3 <= x1 + 200, and x1 <= 500
var 0..1150: x4;                        % x4 >= x2 + 150, and x2 <= 1000

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 2*x1 + 3*x2 >= min_service;
constraint abs(x3 - x1) <= balance_limit;
constraint x4 >= x2 + x4_more_than_x2;

% Objective: minimize total operating cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum total operating cost = ", show(total_cost), "\n"
];