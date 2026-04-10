% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of float: cost = [0.5, 0.3, 0.4, 0.6];

int: X1_min = 0;    int: X1_max = 2000;
int: X2_min = 0;    int: X2_max = 1500;
int: X3_min = 500;  int: X3_max = 1500;
int: X4_min = 500;  int: X4_max = 2000;

% Variables
var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;
var X4_min..X4_max: X4;

% Cost scaled by 10 to keep integer objective (since costs have one decimal)
var 0..20000: total_cost_x10;

% Constraints
constraint X1 + X2 <= 5000;
constraint X2 >= X3 + 1000;
constraint X3 + 2 * X4 <= 3000;
constraint X4 >= X1 + 100;

constraint total_cost_x10 =
    5 * X1 + 3 * X2 + 4 * X3 + 6 * X4;

% Objective
solve minimize total_cost_x10;

% (Optional) Output rounded to one decimal place (in thousands)
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total cost (thousands) = ", show(total_cost_x10 div 10), ".", show(total_cost_x10 mod 10), "\n"
];