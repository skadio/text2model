int: max_x1 = 800;
int: max_x2 = 700;
int: max_x3 = 500;
int: max_x4 = 200;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + 3*x4 <= 1500;
constraint x1 >= (x3 div 2) + 300;   % integer "half" for integrality
constraint x4 - x2 <= 400;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 60*x2 + 30*x3 + 20*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];