% Resource allocation / transportation-style LP as an integer program (all vars are integers)

% Data (embedded as requested)
int: c1 = 100;
int: c2 = 200;
int: c3 = 150;
int: c4 = 250;

int: x1_max = 5000;
int: x2_max = 5000;
int: x3_max = 6000;
int: x4_max = 6000;

% Decision variables (whole-number allocations)
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

% Constraints
constraint x1 + x2 <= 5000;
constraint x3 + x4 <= 6000;
constraint x1 + x3 >= 3000;
constraint x2 + x4 >= 4000;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];