int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
%        A   B   C   D   E
  [|     0, 95, 36, 93, 16  % A
   |    95,  0, 95, 29, 96  % B
   |    36, 95,  0, 72, 38  % C
   |    93, 29, 72,  0, 77  % D
   |    16, 96, 38, 77,  0  % E
  |];

array[CITIES] of var CITIES: succ;  % successor city in the tour
array[CITIES] of var CITIES: pred;  % predecessor city in the tour

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

% Ensure a single Hamiltonian cycle visiting all cities exactly once
constraint circuit(succ);
constraint inverse(succ, pred);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor representation (city -> next):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];