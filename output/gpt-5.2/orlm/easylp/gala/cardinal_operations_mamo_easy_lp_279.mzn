include "globals.mzn";

% Data (embedded from problem statement)
int: cap = 50;
int: costX = 150;
int: costY = 200;
int: costZ = 100;

% Decision variables: number of tourists in each package (whole numbers)
var 0..cap: x;
var 0..cap: y;
var 0..cap: z;

% Total tourists capacity
constraint x + y + z <= cap;

% Operational efficiency: 2*X + 3*Y + 1*Z >= 60
constraint 2*x + 3*y + z >= 60;

% Balanced distribution: |Y - Z| <= 10
constraint abs(y - z) <= 10;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_tourists = ", show(x + y + z), "\n",
  "total_cost = ", show(total_cost), "\n"
];