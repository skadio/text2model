% Traveling Salesman Problem over 5 warehouses (A..E)
% Minimize total travel cost visiting each warehouse exactly once and returning to start.

include "circuit.mzn";

set of int: N = 1..5;  % 1:A, 2:B, 3:C, 4:D, 5:E

array[N,N] of int: cost =
[
  %   A   B   C   D   E
  [  0, 15, 88, 54, 92],  % A
  [ 15,  0, 29, 98, 33],  % B
  [ 88, 29,  0, 96, 96],  % C
  [ 54, 98, 96,  0, 63],  % D
  [ 92, 33, 96, 63,  0]   % E
];

array[N] of var N: succ;          % succ[i] = next warehouse visited after i
var int: total_cost = sum(i in N) (cost[i, succ[i]]);

constraint circuit(succ);

solve minimize total_cost;

function string: name(int: i) =
  if i == 1 then "A"
  elseif i == 2 then "B"
  elseif i == 3 then "C"
  elseif i == 4 then "D"
  else "E" endif;

% Recover a concrete tour starting at A for display (any rotation is equivalent)
array[1..5] of var N: tour;
constraint tour[1] = 1;
constraint forall(k in 1..4)(tour[k+1] = succ[tour[k]]);

output [
  "Minimum total cost: ", show(total_cost), "\n",
  "Successors (A..E): ", show(succ), "\n",
  "Tour (starting at A): ",
  concat([ if k==1 then name(fix(tour[k])) else " -> " ++ name(fix(tour[k])) endif | k in 1..5 ]),
  " -> A\n"
];