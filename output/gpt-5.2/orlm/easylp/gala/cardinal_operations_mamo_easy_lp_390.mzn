% Course enrollment planning (all data embedded)

% Decision variables: number of students in each course
var 0..20: x1;   % course x1
var 0..30: x2;   % course x2
var 0..15: x3;   % course x3
var 0..20: x4;   % course x4

% Constraints (capacity / availability)
constraint x1 + x2 <= 25;
constraint x3 + x4 <= 15;

% Balance constraints
constraint x1 + x3 >= 10;
constraint x2 + x4 >= 20;

% Objective: minimize total cost
var int: total_cost = 200*x1 + 100*x2 + 500*x3 + 300*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];