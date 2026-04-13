include "globals.mzn";

/* Embedded data (as required) */
int: X_min = 0;
int: X_max = 5;
int: Y_min = 0;
int: Y_max = 4;

int: costX = 5000;
int: costY = 7000;

/* Decision variables */
var X_min..X_max: X;
var Y_min..Y_max: Y;

/* Constraints */
constraint 2 * X + 3 * Y >= 10;   % combined strength requirement
constraint X + Y <= 8;            % manpower limit
constraint Y >= X + 1;            % Y at least one more than X

/* Objective */
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];