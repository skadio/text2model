include "globals.mzn";

% Data (embedded from problem statement)
int: maxTours = 50;

int: ratingX = 5;
int: ratingY = 3;
int: ratingZ = 7;
int: minTotalRating = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

int: minXminusY = 10;

% Decision variables: number of tours in each package (whole numbers)
var 0..maxTours: x;
var 0..maxTours: y;
var 0..maxTours: z;

% Constraints
constraint x + y + z <= maxTours;
constraint ratingX * x + ratingY * y + ratingZ * z >= minTotalRating;
constraint x >= y + minXminusY;

% Objective: minimize total cost
var 0..(maxTours * max(costX, max(costY, costZ))): totalCost =
  costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = $", show(totalCost), "\n"
];