% Parameters (with values embedded)
int: X1_lb = 0;
int: X1_ub = 24;
int: X2_lb = 0;
int: X2_ub = 12;
int: X3_lb = 0;
int: X3_ub = 30;

int: c1 = 5;
int: c2 = 6;
int: c3 = 3;

% Variables
var X1_lb..X1_ub: X1;
var X2_lb..X2_ub: X2;
var X3_lb..X3_ub: X3;

var 0..(c1*X1_ub + c2*X2_ub + c3*X3_ub): total_cost;

% Constraints
constraint 2*X1 + 3*X2 + 1*X3 >= 10;
constraint 4*X1 + 5*X2 + 2*X3 <= 20;
constraint 1*X1 - 2*X2 + 1*X3 >= 8;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];