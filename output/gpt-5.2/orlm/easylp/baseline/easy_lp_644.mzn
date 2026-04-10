% Resource allocation for environmental protection projects
% All data embedded; integer allocations.

int: x1_min = 0;   int: x1_max = 400;
int: x2_min = 0;   int: x2_max = 300;
int: x3_min = 50;  int: x3_max = 200;
int: x4_min = 30;  int: x4_max = 60;

var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint 2*x1 + 3*x3 >= 300;
constraint x4 - (x2 div 2) <= 100;              % x4 <= 0.5*x2 + 100, with integer half
constraint x2 + x4 - x1 - x3 = 80;

% Objective: minimize total cost
% Use integer scaling to avoid floats: costs 0.5,0.3,0.4,0.6 -> multiply by 10 => 5,3,4,6
var int: cost10 = 5*x1 + 3*x2 + 4*x3 + 6*x4;
solve minimize cost10;

% Rounded-off minimum total cost (in original units)
var int: rounded_cost = (cost10 + 5) div 10;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_cost10=", show(cost10), " (i.e., cost=", show(cost10/10.0), ")\n",
  "rounded_min_cost=", show(rounded_cost), "\n"
];