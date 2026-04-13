% Bandwidth allocation problem (integer linear optimization)
include "globals.mzn";

% Embedded data (from problem statement)
int: total_bw = 10000;
int: costX = 20;
int: costY = 30;

% Decision variables: whole-number bandwidth units
var 0..total_bw: x;  % allocation to service X
var 0..total_bw: y;  % allocation to service Y

% Constraints
constraint x + y <= total_bw;

% x - 0.5y >= 3000  =>  2x - y >= 6000
constraint 2 * x - y >= 6000;

% y - 0.75x <= 2000  =>  4y - 3x <= 8000
constraint 4 * y - 3 * x <= 8000;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];