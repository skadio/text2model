include "globals.mzn";

% Fatigue per hour
int: c1 = 2;   % Team X1
int: c2 = 3;   % Team X2
int: c3 = 4;   % Team X3
int: c4 = 5;   % Team X4

% Decision variables: whole hours for each team (nonnegative integers)
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

% Constraints
constraint x1 + x2 <= 8;
constraint 2*x2 + x3 >= 10;
constraint x3 - 3*x4 <= 15;
constraint x4 - x1 = 5;

% Objective: minimize total fatigue score
var int: total_fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_fatigue=", show(total_fatigue), "\n",
  "rounded_min_total_fatigue=", show(total_fatigue), "\n"
];