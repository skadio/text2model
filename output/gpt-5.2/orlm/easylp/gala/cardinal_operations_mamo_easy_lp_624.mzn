% Supply chain resource allocation - standalone MiniZinc model
include "globals.mzn";

% Data (embedded as required)
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 1000;
int: cap34 = 1200;

int: diff12 = 200;   % 0.7*x1 - 0.8*x2 >= 200
int: diff43 = 300;   % x4 - x3 >= 300

% Decision variables (integer allocations, nonnegative)
var 0..cap12: x1;
var 0..cap12: x2;

var 0..cap34: x3;
var 0..cap34: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Avoid floats by scaling by 10: 7*x1 - 8*x2 >= 2000
constraint 7*x1 - 8*x2 >= 10*diff12;

constraint x4 - x3 >= diff43;

% Objective: minimize total cost.
% Scale by 2 to keep objective integral: 2*cost = 3*x1 + 4*x2 + 6*x3 + 8*x4
var int: obj2 = 3*x1 + 4*x2 + 6*x3 + 8*x4;

solve minimize obj2;

% Output: minimum total cost rounded down (floor). Since cost = obj2/2, floor(cost) = obj2 div 2.
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "obj2=", show(obj2), "\n",
  "min_total_cost_floor=", show(obj2 div 2), "\n"
];