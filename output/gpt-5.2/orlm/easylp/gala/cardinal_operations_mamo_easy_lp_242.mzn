include "globals.mzn";

/* Data (embedded from description) */
int: maxProjects = 50;
int: minEffect   = 150;

int: effX = 3;
int: effY = 4;
int: effZ = 5;

int: costX = 2000;
int: costY = 3000;
int: costZ = 4000;

int: maxDiffXY = 10;

/* Decision variables: number of projects of each type (integers) */
var 0..maxProjects: x;
var 0..maxProjects: y;
var 0..maxProjects: z;

/* Constraints */
constraint x + y + z <= maxProjects;
constraint effX*x + effY*y + effZ*z >= minEffect;
constraint abs(x - y) <= maxDiffXY;

/* Objective: minimize total cost */
var 0..(maxProjects * max([costX, costY, costZ])): totalCost;
constraint totalCost = costX*x + costY*y + costZ*z;

solve minimize totalCost;

output [
  "Minimum total cost ($) = ", show(totalCost), "\n",
  "x = ", show(x), ", y = ", show(y), ", z = ", show(z), "\n",
  "Total projects = ", show(x+y+z), "\n",
  "Effectiveness = ", show(effX*x + effY*y + effZ*z), "\n"
];