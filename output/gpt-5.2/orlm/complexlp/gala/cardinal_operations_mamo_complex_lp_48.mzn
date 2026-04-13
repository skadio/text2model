include "globals.mzn";

% Transportation / redistribution model (min-cost flow)

int: n = 7;
set of int: F = 1..n;

array[F] of int: supply0 = [229, 345, 231, 164, 354, 437, 265];
array[F] of int: demand  = [158,  14, 326, 432, 207, 215, 233];

% cost[i,j] = unit cost to ship from facility i to facility j
array[F, F] of int: cost =
[
  % to:   1   2   3   4   5   6   7
        [ 0, 26,  8,  7, 34, 35, 34], % from 1
        [41,  0, 27, 31,  3, 33, 36], % from 2
        [20, 49,  0, 48, 21, 38, 42], % from 3
        [10, 35, 26,  0, 21, 33, 31], % from 4
        [21, 30, 24, 25,  0,  5,  8], % from 5
        [27, 34, 34, 26, 27,  0, 43], % from 6
        [38, 20, 11, 43, 49,  9,  0]  % from 7
];

% Check feasibility: total supply must equal total demand
constraint sum(i in F)(supply0[i]) = sum(i in F)(demand[i]);

% Decision variables: shipped units from i to j (no self-shipments)
int: U = sum(i in F)(supply0[i]);
array[F, F] of var 0..U: x;

constraint forall(i in F)(x[i,i] = 0);

% Flow balance:
% initial supply - outgoing + incoming = final demand
constraint forall(i in F)(
  supply0[i] - sum(j in F)(x[i,j]) + sum(j in F)(x[j,i]) = demand[i]
);

% Objective: minimize total transportation cost
var int: total_cost = sum(i in F, j in F)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipment matrix x (from rows i to columns j):\n",
  concat([ concat([ if j = 1 then "" else " " endif ++ show(x[i,j]) | j in F]) ++ "\n" | i in F ])
];