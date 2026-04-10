include "globals.mzn";

% Data embedded from problem description
int: n = 20;
array[1..3] of int: cost = [5000, 4000, 6000]; % 1=X, 2=Y, 3=Z
array[1..3] of int: lo   = [5, 3, 2];

% Decision: project assignment for each employee
array[1..n] of var 1..3: proj; % 1=X, 2=Y, 3=Z

% Count employees per project
var 0..n: nX;
var 0..n: nY;
var 0..n: nZ;

constraint count(proj, 1, nX);
constraint count(proj, 2, nY);
constraint count(proj, 3, nZ);

% Minimum staffing requirements
constraint nX >= lo[1];
constraint nY >= lo[2];
constraint nZ >= lo[3];

% Total must be 20 employees
constraint nX + nY + nZ = n;

% Objective: minimize total cost
var int: totalCost = cost[1]*nX + cost[2]*nY + cost[3]*nZ;

solve minimize totalCost;

output [
  "Minimum total cost = $", show(totalCost), "\n",
  "Allocation: X=", show(nX), ", Y=", show(nY), ", Z=", show(nZ), "\n"
];