include "globals.mzn";

% China Railroad freight car relocation (min-cost transportation)

int: n = 5;
set of int: R = 1..n;

% Costs c[i,j] = cost to move one car from region i to region j
array[R, R] of int: c =
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

% Current cars (supply) and required cars (demand)
array[R] of int: current = [115, 385, 410, 480, 610];
array[R] of int: need    = [200, 500, 800, 200, 300];

% Net surplus (positive) / deficit (negative)
array[R] of int: balance = [ current[i] - need[i] | i in R ];
% balance = [-85, -115, -390, 280, 310]; total = 0 (feasible)

% Decision: x[i,j] = number of cars moved from region i to region j
array[R, R] of var 0..10000: x;

% No reason to ship to self (can be left free, but fix to 0 for clarity)
constraint forall(i in R)(x[i,i] = 0);

% Flow conservation to satisfy needs:
% final_i = current_i - out_i + in_i = need_i
constraint forall(i in R)(
  sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = need[i] - current[i]
);

% Objective: minimize total transportation cost
var int: totalCost = sum(i in R, j in R)(c[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Minimum total cost = ", show(totalCost), "\n",
  "Shipments x[i,j] (cars moved from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j])
                    | j in R ]) ++ "\n"
          | i in R ])
];