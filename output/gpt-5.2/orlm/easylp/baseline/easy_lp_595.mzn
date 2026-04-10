% Resource allocation for projects X1..X4 (integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Costs per unit allocation
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

% Constraints
constraint x1 + x2 <= 1000;
constraint x2 + x3 >= 800;
constraint x3 - x4 = 200;
% Half of x4 minus x1 should not exceed 300:
% (x4/2) - x1 <= 300  <=>  x4 - 2*x1 <= 600
constraint x4 - 2*x1 <= 600;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost_rounded=", show(total_cost), "\n"
];