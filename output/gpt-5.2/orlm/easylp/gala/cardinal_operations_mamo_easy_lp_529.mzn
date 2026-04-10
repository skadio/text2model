include "globals.mzn";

/* Data (embedded as required) */
int: BUDGET = 2000;

int: invMax = 1500;
int: advMax = 800;
int: csMax  = 1200;

int: cInv = 5;
int: cAdv = 3;
int: cCS  = 7;

/* Decision variables: whole-number allocations */
var 0..invMax: x1; % inventory
var 0..advMax: x2; % advertising
var 0..csMax:  x3; % customer service

/* Constraints */
constraint x1 + x2 + x3 <= BUDGET;

/* 2*x1 - 0.5*x2 >= 500  <=>  4*x1 - x2 >= 1000 */
constraint 4 * x1 - x2 >= 1000;

/* x3 - 0.8*x1 <= 1000  <=>  5*x3 - 4*x1 <= 5000 */
constraint 5 * x3 - 4 * x1 <= 5000;

/* Objective: minimize total cost */
var int: total_cost = cInv * x1 + cAdv * x2 + cCS * x3;

solve minimize total_cost;

/* Output */
output [
  "x1 (inventory) = ", show(x1), "\n",
  "x2 (advertising) = ", show(x2), "\n",
  "x3 (customer service) = ", show(x3), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];