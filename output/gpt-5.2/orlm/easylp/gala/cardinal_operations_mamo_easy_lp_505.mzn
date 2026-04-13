include "globals.mzn";

/* Decision variables: dollars allocated to each channel (whole dollars) */
var 0..2500: x;   % Channel X max 2500
var 0..1500: y;   % Channel Y max 1500
var 0..4000: z;   % Channel Z max 4000

/* Total budget must not exceed $5000 */
constraint x + y + z <= 5000;

/* X at least $50 more than Y */
constraint x >= y + 50;

/* Z close to X and Y within given bounds */
constraint abs(z - x) <= 1000;
constraint abs(z - y) <= 200;

/* Costs per unit impact (interpreted as linear cost coefficients) */
int: costX = 500;
int: costY = 300;
int: costZ = 1000;

/* Objective: minimize total cost */
var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];