include "globals.mzn";

/* Data (embedded as required) */
int: n = 100;
set of int: DEPT = 1..3;                 % 1=X, 2=Y, 3=Z
array[DEPT] of int: minReq = [20, 15, 10];
array[DEPT] of int: costPerHire = [50, 80, 30];

/* Decision variables: department assignment for each of the 100 hires */
array[1..n] of var DEPT: dept;

/* Counts per department */
var 0..n: cntX;
var 0..n: cntY;
var 0..n: cntZ;
constraint count(dept, 1, cntX);
constraint count(dept, 2, cntY);
constraint count(dept, 3, cntZ);

/* Minimum staffing requirements */
constraint cntX >= minReq[1];
constraint cntY >= minReq[2];
constraint cntZ >= minReq[3];

/* All hires must be assigned to exactly one department (already ensured by domain).
   Also, total assigned equals n (redundant but strengthening). */
constraint cntX + cntY + cntZ = n;

/* Objective: minimize total training cost */
var int: totalCost = cntX * costPerHire[1] + cntY * costPerHire[2] + cntZ * costPerHire[3];

solve minimize totalCost;

output [
  "cntX = ", show(cntX), "\n",
  "cntY = ", show(cntY), "\n",
  "cntZ = ", show(cntZ), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];