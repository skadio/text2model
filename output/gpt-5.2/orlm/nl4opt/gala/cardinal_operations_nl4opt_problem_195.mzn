include "globals.mzn";

/* Data (embedded from problem statement) */
int: ironA = 5;
int: calA  = 10;
int: costA = 2;

int: ironB = 4;
int: calB  = 15;
int: costB = 3;

int: minIron = 40;
int: minCal  = 50;

/* Decision variables: number of pills to buy (nonnegative integers) */
var 0..100: a;   % pills of supplement A
var 0..100: b;   % pills of supplement B

/* Constraints: meet minimum requirements */
constraint ironA * a + ironB * b >= minIron;
constraint calA  * a + calB  * b >= minCal;

/* Objective: minimize total cost */
var int: totalCost = costA * a + costB * b;

solve minimize totalCost;

output [
  "A pills = ", show(a), "\n",
  "B pills = ", show(b), "\n",
  "Total cost = $", show(totalCost), "\n",
  "Iron = ", show(ironA*a + ironB*b), "\n",
  "Calcium = ", show(calA*a + calB*b), "\n"
];