include "globals.mzn";

/* Data (embedded from the problem description) */
int: maxTasks = 8;
int: effortX = 4;
int: effortY = 2;
int: effortZ = 3;

/* Decision variables: number of tasks of each type (whole numbers) */
var 0..maxTasks: X;
var 0..maxTasks: Y;
var 0..maxTasks: Z;

/* Constraints */
constraint X + Y + Z <= maxTasks;
constraint X + Y >= 3;
constraint Y + Z <= 5;

/* Objective: minimize total effort */
var 0..(maxTasks * max(effortX, max(effortY, effortZ))): totalEffort;
constraint totalEffort = effortX * X + effortY * Y + effortZ * Z;

solve minimize totalEffort;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total effort (rounded) = ", show(totalEffort), "\n"
];