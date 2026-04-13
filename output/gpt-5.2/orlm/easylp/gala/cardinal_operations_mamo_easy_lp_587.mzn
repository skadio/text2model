include "globals.mzn";

% Decision variables: integer investments in each project
var 0..400: x1;
var 0..350: x2;
var 0..250: x3;
var 0..150: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 300;
constraint x1 + x3 >= 200;

% Difference constraint: x2 - 0.5*x4 >= 100
% Use integer form to avoid fractions: 2*x2 - x4 >= 200
constraint 2*x2 - x4 >= 200;

% Objective: minimize total cost
var int: total_cost = 60*x1 + 50*x2 + 70*x3 + 80*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];