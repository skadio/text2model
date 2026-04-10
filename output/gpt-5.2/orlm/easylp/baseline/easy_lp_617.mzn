% Resource allocation for 4 projects with integer allocations
% Objective: minimize total cost

int: max_x1 = 1000;
int: max_x2 = 1000;
int: max_x3 = 2400;
int: max_x4 = 1000;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x2 + x3 <= 1200;

% 3*x1 - 0.5*x3 >= 500  -> multiply by 2 to keep integers: 6*x1 - x3 >= 1000
constraint 6*x1 - x3 >= 1000;

constraint x4 >= x1;

% Objective
var int: total_cost = 200*x1 + 300*x2 + 150*x3 + 400*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "rounded_min_total_cost=", show(total_cost), "\n"
];