include "globals.mzn";

% Food redistribution / transportation (min-cost flow)

int: n = 6;
set of int: R = 1..n;

array[R] of int: have = [42, 32, 398, 224, 210, 209];
array[R] of int: need = [74, 476, 2, 235, 221, 72];

% Transportation costs per ton from i -> j (i != j), diagonal unused (0)
array[R, R] of int: cost =
array2d(R, R,
[
  0, 16, 48, 42, 50,  8,
 27,  0, 23, 37, 39, 29,
 49, 39,  0, 33, 50,  6,
 23, 49, 46,  0, 50,  6,
 45, 47, 48, 26,  0, 39,
 33, 11,  9,  4, 12,  0
]);

% Total food is sufficient
constraint sum(have) >= sum(need);

int: totalHave = sum(have);

% x[i,j] = tons shipped from region i to region j
array[R, R] of var 0..totalHave: x;

% No self-shipment
constraint forall(i in R)( x[i,i] = 0 );

% Flow balance: final amount in each region must be >= need
% final[i] = have[i] - outgoing + incoming
constraint forall(i in R)(
  have[i] - sum(j in R)(x[i,j]) + sum(j in R)(x[j,i]) >= need[i]
);

% Cannot ship more than you have (optional tightening; implied by balances but helps)
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= have[i]
);

% Objective: minimize transportation cost
var int: totalCost = sum(i in R, j in R)( cost[i,j] * x[i,j] );

solve minimize totalCost;

output [
  "Minimum cost = ", show(totalCost), "\n",
  "Shipments x[i,j] (tons):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in R ]) ++ "\n" | i in R ])
];