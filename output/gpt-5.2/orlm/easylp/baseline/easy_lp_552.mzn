% Human resources allocation - minimize total cost

int: TOTAL_MAX = 10;

int: c1 = 50000;
int: c2 = 60000;
int: c3 = 70000;

% Staffing bounds (given)
int: X1_LB = 0; int: X1_UB = 6;
int: X2_LB = 0; int: X2_UB = 4;
int: X3_LB = 0; int: X3_UB = 5;

% Minimum requirements (given)
int: X1_MIN = 2;
int: X2_MIN = 3;
int: X3_MIN = 5;

var X1_LB..X1_UB: X1;
var X2_LB..X2_UB: X2;
var X3_LB..X3_UB: X3;

constraint X1 + X2 + X3 <= TOTAL_MAX;
constraint X1 >= X1_MIN;
constraint X2 >= X2_MIN;
constraint X3 >= X3_MIN;

var int: total_cost = c1*X1 + c2*X2 + c3*X3;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];