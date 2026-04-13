include "globals.mzn";

% ----- Data (embedded as requested) -----
int: n = 4;
set of int: W = 1..n;

array[W] of int: stock = [500, 497, 354, 223];
array[W] of int: req   = [ 17,  65,  26, 332];

% cost[i,j] = cost to move 1 ton from warehouse i to warehouse j (i != j)
array[W, W] of int: cost =
  [|  0, 17,  3,  5
   | 39,  0, 18, 50
   |  8, 45,  0, 15
   | 11,  4, 29,  0 |];

% ----- Model -----
% x[i,j] = tons moved from i to j
array[W, W] of var 0..max(stock): x;

% No self-shipments
constraint forall(i in W)( x[i,i] = 0 );

% Flow balance at each warehouse:
% final[i] = stock[i] - outgoing + incoming = req[i]
constraint forall(i in W)(
  stock[i] - sum(j in W)(x[i,j]) + sum(j in W)(x[j,i]) = req[i]
);

% Objective: minimize total transport cost
var int: total_cost = sum(i in W, j in W)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [ show(total_cost), "\n" ];