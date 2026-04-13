% Traveling Salesperson Problem (4 cities), data embedded

int: n = 4;
set of int: Cities = 1..n;

% City indices: 1=A, 2=B, 3=C, 4=D
array[Cities, Cities] of int: cost =
[
  %  A   B   C   D
  [  0, 61, 65, 63], % A
  [ 61,  0, 94, 31], % B
  [ 65, 94,  0, 19], % C
  [ 63, 31, 19,  0]  % D
];

% succ[i] = next city visited after i
array[Cities] of var Cities: succ;

% One Hamiltonian cycle over all cities
constraint circuit(succ);

var int: total_cost =
  sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (1=A,2=B,3=C,4=D):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in Cities ])
];