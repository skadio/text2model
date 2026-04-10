% Beverage production planning over 4 weeks
% Minimize production + inventory holding costs while meeting weekly demand.

include "globals.mzn";

int: T = 4;
set of int: W = 1..T;

array[W] of int: demand = [15, 25, 35, 25];      % 1000 boxes
array[W] of int: cap    = [30, 40, 45, 20];      % 1000 boxes
array[W] of float: prodCost = [5.0, 5.1, 5.4, 5.5]; % 1000 yuan per 1000 boxes
float: holdCost = 0.2;                          % 1000 yuan per 1000 boxes per week

% Upper bound for inventory: total possible production
int: invUB = sum(w in W)(cap[w]);

% Decision variables
array[W] of var 0..invUB: prod;   % production in week w (1000 boxes)
array[W] of var 0..invUB: inv;    % end-of-week inventory after meeting demand (1000 boxes)

% Capacity constraints
constraint forall(w in W)( prod[w] <= cap[w] );

% Inventory balance:
% inv[w] = inv[w-1] + prod[w] - demand[w], inv[0] = 0
constraint inv[1] = prod[1] - demand[1];
constraint forall(w in 2..T)( inv[w] = inv[w-1] + prod[w] - demand[w] );

% No backlogging (inventory is nonnegative by domain), hence demand met each week.

% Objective: production cost + holding cost (holding charged on end-of-week inventory)
var float: totalProdCost = sum(w in W)( prodCost[w] * int2float(prod[w]) );
var float: totalHoldCost = sum(w in W)( holdCost * int2float(inv[w]) );
var float: totalCost = totalProdCost + totalHoldCost;

solve minimize totalCost;

output [
  "Production (1000 boxes) by week = ", show(prod), "\n",
  "End inventory (1000 boxes) by week = ", show(inv), "\n",
  "Total production cost (1000 yuan) = ", show(totalProdCost), "\n",
  "Total holding cost (1000 yuan) = ", show(totalHoldCost), "\n",
  "Total cost (1000 yuan) = ", show(totalCost), "\n"
];