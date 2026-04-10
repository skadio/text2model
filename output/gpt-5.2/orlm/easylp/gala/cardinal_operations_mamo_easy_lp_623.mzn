include "globals.mzn";

/*
Supply chain resource allocation (integer decision variables)
Minimize total cost:
  4*X1 + 3*X2 + 5*X3 + 6*X4

Constraints:
  X1 + X2 <= 1000
  2*X2 + X3 >= 500
  0.5*X3 - X1 <= 200          -> X3 - 2*X1 <= 400
  X4 - X2 >= -400
  0.8*X4 - X3 <= -300         -> 4*X4 - 5*X3 <= -1500
*/

% Safe integer bounds derived from constraints (keeps model bounded and efficient)
int: X1_min = 0;
int: X1_max = 1000;

int: X2_min = 0;
int: X2_max = 1000;

int: X3_min = 0;
int: X3_max = 1400; % from X3 <= 400 + 2*X1 and X1<=1000

int: X4_min = 0;
int: X4_max = 1750; % from 4*X4 <= 5*X3 - 1500 and X3<=1400

var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;
var X4_min..X4_max: X4;

% Constraints
constraint X1 + X2 <= 1000;
constraint 2*X2 + X3 >= 500;
constraint X3 - 2*X1 <= 400;
constraint X4 - X2 >= -400;
constraint 4*X4 - 5*X3 <= -1500;

% Objective
var int: total_cost = 4*X1 + 3*X2 + 5*X3 + 6*X4;
solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Minimum total cost (nearest whole) = ", show(total_cost), "\n"
];