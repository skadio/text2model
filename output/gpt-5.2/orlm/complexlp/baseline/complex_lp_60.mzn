% Traveling Salesperson Problem (4 cities: A,B,C,D)
% Visit each city exactly once and return to the start; start can be any city.

int: n = 4;
set of int: Cities = 1..n;

% City indices: 1=A, 2=B, 3=C, 4=D
array[Cities, Cities] of int: cost = array2d(Cities, Cities, [
  0, 19, 45, 30,
  19, 0, 89, 46,
  45, 89, 0, 11,
  30, 46, 11, 0
]);

% successor[i] = next city visited after city i (forms one Hamiltonian cycle)
array[Cities] of var Cities: successor;
constraint forall(i in Cities)(successor[i] != i);
constraint circuit(successor);

var int: total_cost = sum(i in Cities)(cost[i, successor[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (1=A,2=B,3=C,4=D): ", show(successor), "\n"
];