% Environmental projects cost minimization (all data embedded)

var int: x1; % units for project 1
var int: x2; % units for project 2
var int: x3; % units for project 3
var int: x4; % units for project 4

% Costs per unit
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

% Nonnegativity (whole units of resources)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Constraints
constraint x1 + x2 <= 50;
constraint x3 >= x4 + 10;
constraint 2*x1 + x3 <= 60;
constraint x2 >= 2*x4 + 5;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];