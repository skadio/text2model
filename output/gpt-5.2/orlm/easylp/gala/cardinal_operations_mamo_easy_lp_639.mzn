include "globals.mzn";

% Data (embedded as requested)
int: ub1 = 20;
int: ub2 = 30;
int: ub3 = 40;
int: ub4 = 50;

int: total_ub = 100;

% Decision variables (integer allocations)
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_ub;

constraint 10*x1 + 20*x2 >= 50;

constraint 3*x3 - 40*x4 <= 10;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2 to avoid fractions: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 140;

% Objective: minimize total cost
var int: total_cost = 200*x1 + 300*x2 + 500*x3 + 1000*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];