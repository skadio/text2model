include "globals.mzn";

% Warehouses: 1=A, 2=B, 3=C, 4=D, 5=E
int: n = 5;
set of int: W = 1..n;

% Travel cost matrix (cost[i,j] = cost from i to j)
array[W, W] of int: cost =
  [| 0, 15, 88, 54, 92
   | 15, 0, 29, 98, 33
   | 88, 29, 0, 96, 96
   | 54, 98, 96, 0, 63
   | 92, 33, 96, 63, 0 |];

% visit_order[k] = warehouse visited at step k (a Hamiltonian cycle; start anywhere)
array[1..n] of var W: visit_order;
constraint all_different(visit_order);

% Total tour cost including return to the starting warehouse
var 0..10000: total_cost;
constraint total_cost =
  sum(k in 1..n-1)( cost[visit_order[k], visit_order[k+1]] )
  + cost[visit_order[n], visit_order[1]];

solve minimize total_cost;

function string: wname(int: w) =
  if w=1 then "A"
  elseif w=2 then "B"
  elseif w=3 then "C"
  elseif w=4 then "D"
  else "E" endif;

output [
  "Total cost = ", show(total_cost), "\n",
  "Route (cycle) = ",
  concat([ wname(visit_order[k]) ++ (if k < n then " -> " else "" endif) | k in 1..n ]),
  " -> ", wname(visit_order[1]), "\n",
  "Visit order = ", show(visit_order), "\n"
];