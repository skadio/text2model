include "globals.mzn";

% Data (embedded)
int: nProd = 3;
int: nMach = 3;

array[1..nProd, 1..nMach] of int: t =
  array2d(1..nProd, 1..nMach,
    [ 2,3,1,
      4,2,3,
      3,5,2 ]);

set of int: PROD = 1..nProd;
set of int: MACH = 1..nMach;

% A safe horizon
int: H = sum(i in PROD, j in MACH)(t[i,j]);

% Decision variables
array[PROD, MACH] of var 0..H: start;
array[PROD, MACH] of var 0..H: finish;

% Fixed common order of products on all machines (flow shop permutation)
% perm[k] is the product processed k-th on every machine
array[1..nProd] of var PROD: perm;
constraint all_different(perm);

% Link finish times
constraint forall(i in PROD, j in MACH)(
  finish[i,j] = start[i,j] + t[i,j]
);

% Each machine processes at most one product at a time (capacity 1)
constraint forall(j in MACH)(
  cumulative([ start[i,j] | i in PROD ],
             [ t[i,j]     | i in PROD ],
             [ 1          | i in PROD ],
             1)
);

% Technological order: machine 1 -> 2 -> 3 for each product
constraint forall(i in PROD, j in 1..nMach-1)(
  start[i, j+1] >= finish[i, j]
);

% Same processing order on every machine:
% if perm[k] precedes perm[k+1], enforce non-overlap in that sequence on each machine
constraint forall(j in MACH, k in 1..nProd-1)(
  start[perm[k+1], j] >= finish[perm[k], j]
);

% Objective: minimize makespan (total processing cycle time)
var 0..H: makespan;
constraint makespan = max([ finish[i, nMach] | i in PROD ]);

solve minimize makespan;

output [
  "Order (perm) = ", show(perm), "\n",
  "Makespan = ", show(makespan), "\n\n",
  "Start times (product x machine):\n",
  concat([ "P" ++ show(i) ++ ": " ++
           concat([ "M" ++ show(j) ++ "=" ++ show(start[i,j]) ++
                    ".." ++ show(finish[i,j]) ++
                    (if j < nMach then "  " else "" endif)
                  | j in MACH ]) ++ "\n"
         | i in PROD ])
];