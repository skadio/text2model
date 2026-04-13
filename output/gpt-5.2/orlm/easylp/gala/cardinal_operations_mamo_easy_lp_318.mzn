include "globals.mzn";

/* Data (embedded from problem statement) */
int: minWeight = 2000;              % tons
int: maxVolume = 3000;              % cubic meters

int: wA = 2; int: wB = 3; int: wC = 4;    % weight contribution per ship
int: vA = 3; int: vB = 2; int: vC = 1;    % volume contribution per ship

int: cA = 7; int: cB = 6; int: cC = 5;    % cost per ship ($)

int: minDiffAB = 500;               % A must be at least 500 more than B

/* Decision variables: integer number of each ship type */
var 0..4000: A;
var 0..4000: B;
var 0..4000: C;

/* Constraints */
constraint wA*A + wB*B + wC*C >= minWeight;
constraint vA*A + vB*B + vC*C <= maxVolume;
constraint A - B >= minDiffAB;

/* Objective: minimize total operational cost */
var int: totalCost = cA*A + cB*B + cC*C;

solve minimize totalCost;

/* Output */
output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "C = ", show(C), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];