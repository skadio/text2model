include "globals.mzn";

% Data (embedded as requested)
int: cost_res = 50000;
int: cost_com = 30000;
int: cost_ind = 70000;

int: max_total = 10;

% Market availability bounds (not explicitly given; use 0..max_total as implied bounds)
int: max_res = max_total;
int: max_com = max_total;
int: max_ind = max_total;

% Decision variables: number of properties of each type
var 0..max_res: x;  % residential
var 0..max_com: y;  % commercial
var 0..max_ind: z;  % industrial

% Constraints
constraint x + y + z <= max_total;
constraint x >= y + 2;
constraint abs(z - x) <= 3;

% Objective: minimize total cost
var int: total_cost = cost_res*x + cost_com*y + cost_ind*z;

solve minimize total_cost;

output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "z (industrial)  = ", show(z), "\n",
  "total_cost      = ", show(total_cost), "\n"
];