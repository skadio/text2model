include "globals.mzn";

% Transportation / redistribution model (min-cost flow)

int: n = 7;
set of int: C = 1..n;

% Initial supplies and required needs (demand) at each center
array[C] of int: start = [97, 458, 473, 380, 34, 399, 163];
array[C] of int: need  = [119, 275, 36, 459, 17, 128, 425];

% Cost to transfer 1 unit from i to j
array[C, C] of int: cost =
  [|  0, 41, 42, 31, 39,  2, 18
   | 48,  0,  9, 22, 47, 29, 39
   | 36, 22,  0, 29, 45, 33, 45
   | 19,  5, 10,  0,  3, 42, 20
   | 13, 10, 21,  7,  0, 35, 11
   |  5, 35, 29, 16, 40,  0,  9
   |  7, 24, 26, 38, 33, 13,  0 |];

% Net surplus (>0) or deficit (<0)
array[C] of int: b = [start[i] - need[i] | i in C];

% Feasibility check (must balance)
constraint sum(i in C)(b[i]) = 0;

% Upper bound on any shipped amount (safe big-M)
int: UB = sum(i in C)(start[i]);

% Decision variables: x[i,j] = units shipped from i to j
array[C, C] of var 0..UB: x;

% No self-shipping
constraint forall(i in C)(x[i,i] = 0);

% Flow balance at each node:
% outgoing - incoming = surplus b[i]
constraint forall(i in C)(
  sum(j in C)(x[i,j]) - sum(j in C)(x[j,i]) = b[i]
);

% Objective: minimize total cost
var int: total_cost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (units from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in C ]) ++ "\n" | i in C ])
];