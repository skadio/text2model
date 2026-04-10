include "globals.mzn";

% Data (embedded from problem description)
int: f1 = 10;
int: f2 = 15;
int: f3 = 20;
int: f4 = 25;

% Decision variables: weekly training hours (nonnegative integers)
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

% Constraints
constraint x1 + x2 <= 12;
constraint x3 + x4 <= 16;
constraint x1 + x3 >= 8;
constraint x2 + x4 >= 10;

% Objective: minimize total fatigue score
var int: total_fatigue = f1*x1 + f2*x2 + f3*x3 + f4*x4;

solve minimize total_fatigue;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_fatigue = ", show(total_fatigue), "\n"
];