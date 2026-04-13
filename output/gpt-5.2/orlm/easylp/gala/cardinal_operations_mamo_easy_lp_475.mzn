include "globals.mzn";

% Data (embedded as requested)
int: max_total = 50;
int: min_total = 10;
int: resX = 100;
int: resY = 150;

% Decision variables: number of packages of each type (whole numbers)
var 0..max_total: x;
var 0..max_total: y;

% Constraints
constraint x + y <= max_total;
constraint x + y >= min_total;

% "x should not exceed twice y by more than 20"  ->  x <= 2*y + 20
constraint x <= 2 * y + 20;

% Objective: minimize total resources
var 0..(max_total * max(resX, resY)): totalRes;
constraint totalRes = resX * x + resY * y;

solve minimize totalRes;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_resources = ", show(totalRes), "\n"
];