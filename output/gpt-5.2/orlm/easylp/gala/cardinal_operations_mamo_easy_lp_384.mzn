include "globals.mzn";

% Costs per hour
int: c1 = 20;
int: c2 = 30;
int: c3 = 50;
int: c4 = 60;

% Decision variables (integer hours within given bounds)
var 0..15: x1; % strength & conditioning
var 0..12: x2; % skill development
var 0..10: x3; % strategy learning
var 0..8:  x4; % recovery sessions

% Constraints
constraint x1 + x2 >= 5;

% |x3 - x4| <= 10
constraint abs(x3 - x4) <= 10;

% 2*x1 + 3*x2 - x4 >= 8
constraint 2*x1 + 3*x2 - x4 >= 8;

% |x1 - x3| <= 6
constraint abs(x1 - x3) <= 6;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];