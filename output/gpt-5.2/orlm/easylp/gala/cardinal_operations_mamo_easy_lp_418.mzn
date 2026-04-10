include "globals.mzn";

% Embedded data from the problem description
int: prodX = 60;
int: prodY = 90;

int: cap = 1200;          % 2*X + 3*Y <= 1200
int: minTotalAlloc = 100; % X + Y >= 100

% Decision variables: integer resource allocations
var 0..cap: x;  % allocation to plant X
var 0..cap: y;  % allocation to plant Y

% Constraints
constraint 2*x + 3*y <= cap;
constraint x >= y;
constraint x + y >= minTotalAlloc;

% Objective: minimize total power production
var 0..(prodX*cap + prodY*cap): totalPower = prodX*x + prodY*y;

solve minimize totalPower;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalPower = ", show(totalPower), "\n",
  "roundedAnswer = ", show(totalPower), "\n"
];