include "globals.mzn";

% Transportation / relocation problem (min-cost flow) between 7 warehouses.
% Data is embedded directly as requested.

int: n = 7;
set of int: W = 1..n;

array[W] of int: supply0 = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: demand  = [499, 173, 293, 158, 15, 78, 278];

% cost[i,j] = cost to move 1 unit from warehouse i to warehouse j
array[W, W] of int: cost =
[
  % to:   1   2   3   4   5   6   7
        [ 0, 36, 36, 48, 10, 20, 48],  % from 1
        [28,  0, 16, 18, 36, 42, 12],  % from 2
        [ 6, 40,  0, 49, 31,  1, 46],  % from 3
        [14, 22,  4,  0,  9, 12,  1],  % from 4
        [50, 44,  7, 48,  0,  7, 25],  % from 5
        [26,  9, 33, 38,  8,  0, 30],  % from 6
        [ 8,  9,  2, 13,  8, 49,  0]   % from 7
];

int: totalSupply = sum(i in W)(supply0[i]);
int: totalDemand = sum(i in W)(demand[i]);

% Feasibility: can only satisfy if totalSupply >= totalDemand (here it is not).
constraint totalSupply >= totalDemand;

% Flow variables: x[i,j] = units moved from i to j
array[W, W] of var 0..totalSupply: x;

% Do not ship to self
constraint forall(i in W)(x[i,i] = 0);

% Inventory balance at each warehouse:
% final[i] = supply0[i] - outgoing + incoming
% Must be at least demand[i]
constraint forall(i in W)(
  supply0[i]
  - sum(j in W)(x[i,j])
  + sum(j in W)(x[j,i])
  >= demand[i]
);

% (Optional tightening) Can't ship more than you start with plus what comes in
% This is implied by non-negativity and objective, but helps propagation.
constraint forall(i in W)(
  sum(j in W)(x[i,j]) <= supply0[i] + sum(j in W)(x[j,i])
);

var int: totalCost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "totalSupply = ", show(totalSupply), "\n",
  "totalDemand = ", show(totalDemand), "\n",
  "Minimum cost = ", show(totalCost), "\n",
  "Flow matrix x (from i rows to j columns):\n",
  concat([ concat([ if fix(x[i,j]) = 0 then "0" else show(x[i,j]) endif
                    ++ if j < n then "\t" else "\n" endif
                  | j in W ])
         | i in W ])
];