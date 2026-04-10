% Real estate development cost minimization

% Decision variables: number of units of property types X and Y (integers)
var 0..7: x;  % type X units, max 7
var 0..6: y;  % type Y units, max 6

% Parameters (all embedded)
int: costX = 50000;
int: costY = 80000;

% Constraints
constraint x + y <= 10;                 % zoning total limit
constraint 2 * x >= y + 6;              % x >= 0.5*y + 3  -> 2x >= y + 6

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];