% Employee allocation across four departments (integers)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Costs per employee
int: c1 = 50;
int: c2 = 40;
int: c3 = 30;
int: c4 = 20;

% Constraints
constraint x1 + x2 >= 15;
constraint x2 + x3 <= 25;
constraint x3 >= x4 + 5;
constraint x1 - 2*x4 <= 10;

% Nonnegativity (employees cannot be negative)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Objective: minimize total salary cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_salary_cost=$", show(total_cost), "\n"
];