include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

% Symmetric travel cost matrix (0 on diagonal)
array[Cities, Cities] of int: cost =
  [|  0, 63, 62, 49, 58, 38
   | 63,  0, 93, 21, 66, 42
   | 62, 93,  0, 26, 99, 96
   | 49, 21, 26,  0, 73, 80
   | 58, 66, 99, 73,  0, 76
   | 38, 42, 96, 80, 76,  0 |];

% Successor representation of a Hamiltonian cycle:
% tour[i] = next city visited after city i
array[Cities] of var Cities: tour;

% Fix starting city to break rotational symmetry: start at city 1
constraint tour[1] != 1;

% Each city has exactly one outgoing arc and one incoming arc
constraint all_different(tour);

% Subtour elimination (MTZ-style): enforce single cycle through all nodes
array[Cities] of var 1..n: pos;
constraint pos[1] = 1;
constraint forall(i in 2..n)(pos[i] >= 2);

constraint forall(i in Cities, j in Cities where i != j /\ i != 1 /\ j != 1)(
  tour[i] = j -> pos[j] = pos[i] + 1
);

% Total travel cost of the cycle
var int: total_cost = sum(i in Cities)( cost[i, tour[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor tour (city -> next city): ", show(tour), "\n"
];