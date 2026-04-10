include "globals.mzn";

/* Data (embedded from problem statement) */
int: maxBudget = 5000;

int: rhs1 = 2000;   % 3X - Y + Z >= 2000
int: rhs2 = 1000;   % X - 2Y + Z >= -1000  (equivalent to X - 2Y - Z <= 1000)
int: rhs3 = 1500;   % X - Y + 3Z >= 1500

int: cX = 60;
int: cY = 75;
int: cZ = 50;

/* Decision variables: whole-number budgets */
var 0..maxBudget: X;
var 0..maxBudget: Y;
var 0..maxBudget: Z;

/* Constraints */
constraint X + Y + Z <= maxBudget;

constraint 3*X - Y + Z >= rhs1;
constraint X - 2*Y + Z >= -rhs2;     % rearranged from X - 2Y - Z <= 1000
constraint X - Y + 3*Z >= rhs3;

/* Objective: minimize total cost */
var 0..(cX*maxBudget + cY*maxBudget + cZ*maxBudget): totalCost =
  cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];