include "globals.mzn";

% Emergency food redistribution / transportation problem (min-cost flow)

int: n = 6;
set of int: R = 1..n;

array[R] of int: supply0 = [268, 222, 357, 128, 465,  48];
array[R] of int: demand0 = [165, 246, 262, 286, 439,  83];

% cost[i,j] = cost per unit shipped from region i to region j
array[R, R] of int: cost =
[
  % to: 1   2   3   4   5   6
        0, 49, 11, 23,  2, 39,   % from 1
       33,  0, 26,  2,  2, 14,   % from 2
       12, 31,  0, 36, 30, 34,   % from 3
       18, 50, 12,  0, 19, 20,   % from 4
        3, 13, 20, 29,  0,  1,   % from 5
        2,  9, 50, 36, 39,  0    % from 6
];

% Net requirements after using local supply:
% positive => needs to receive, negative => has surplus to ship out.
array[R] of int: net = [demand0[i] - supply0[i] | i in R];
array[R] of int: deficit = [max(0, net[i]) | i in R];
array[R] of int: surplus = [max(0, -net[i]) | i in R];

int: total_deficit = sum(i in R)(deficit[i]);  % equals total_surplus here

% x[i,j] = units shipped from i to j (i != j)
array[R, R] of var 0..total_deficit: x;

% No self-shipping
constraint forall(i in R)(x[i,i] = 0);

% Surplus nodes: total outflow <= surplus
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= surplus[i]
);

% Deficit nodes: total inflow >= deficit
constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= deficit[j]
);

% Global balance: total shipped equals total deficit (so deficits are met exactly overall)
constraint sum(i in R, j in R)(x[i,j]) = total_deficit;

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (units):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(x[i,j]) | j in R]) ++ "\n" | i in R ])
];