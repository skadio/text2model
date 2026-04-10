% Resource allocation across 4 departments with embedded data

int: max_x1 = 800;
int: max_x2 = 800;
int: max_x3 = 800;
int: max_x4 = 800;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 >= 500;

% "Twice x1 should not fall short of half x3 by less than 300":
% 2*x1 >= 0.5*x3 - 300  -> 4*x1 >= x3 - 600
constraint 4*x1 >= x3 - 600;

% "Difference (x1+x2) minus x4 should not exceed 400": (x1+x2) - x4 <= 400
constraint x1 + x2 - x4 <= 400;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];