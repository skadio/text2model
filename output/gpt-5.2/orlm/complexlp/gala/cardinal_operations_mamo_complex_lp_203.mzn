% Solar Oil blending problem (linear profit maximization)
% Data embedded as requested.

include "globals.mzn";

set of int: R = 1..4;         % raw gasolines
set of int: P = 1..2;         % products: 1=regular, 2=premium

array[R] of float: oct_raw = [86.0, 88.0, 92.0, 96.0];
array[R] of float: cost_raw = [17.0, 18.0, 20.5, 23.0];
array[R] of float: avail   = [20000.0, 15000.0, 15000.0, 10000.0];

array[P] of float: min_oct = [89.0, 93.0];
array[P] of float: price   = [19.5, 22.0];
array[P] of float: demand  = [35000.0, 23000.0];

% Decision variables: barrels of raw r used in product p
array[R, P] of var 0.0..max(avail): x;

% Production volumes for each product
array[P] of var 0.0..(sum(r in R)(avail[r])): prod;

constraint forall(p in P)(
  prod[p] = sum(r in R)(x[r,p])
);

% Raw availability constraints
constraint forall(r in R)(
  sum(p in P)(x[r,p]) <= avail[r]
);

% Demand constraints
constraint forall(p in P)(
  prod[p] <= demand[p]
);

% Octane (weighted average) constraints:
% sum(oct_raw[r]*x[r,p]) / prod[p] >= min_oct[p]
% Linearized as: sum(oct_raw[r]*x[r,p]) >= min_oct[p] * prod[p]
constraint forall(p in P)(
  sum(r in R)(oct_raw[r] * x[r,p]) >= min_oct[p] * prod[p]
);

% Objective: maximize profit = revenue - raw material cost
var float: revenue = sum(p in P)(price[p] * prod[p]);
var float: rawcost = sum(r in R, p in P)(cost_raw[r] * x[r,p]);
var float: profit = revenue - rawcost;

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Production (regular,premium) = ", show([prod[1], prod[2]]), "\n",
  "Blend matrix x[r,p] (rows raw 1..4, cols reg,prem):\n",
  concat([ "raw " ++ show(r) ++ ": " ++ show([x[r,1], x[r,2]]) ++ "\n" | r in R ])
];