% Parameters (with values embedded)
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 73, 39, 79, 38
 | 73,  0, 30, 46, 29
 | 39, 30,  0, 88, 57
 | 79, 46, 88,  0, 59
 | 38, 29, 57, 59,  0 |];

% Variables
array[CITIES] of var CITIES: next;     % successor city for each city
array[CITIES] of var 0..n-1: pos;      % position in tour (MTZ)
var 0..10000: total_cost;

% Constraints
constraint circuit(next);

% MTZ subtour elimination (fix a reference city to break symmetry)
constraint pos[1] = 0;
constraint forall(i in 2..n)(pos[i] >= 1 /\ pos[i] <= n-1);
constraint forall(i in 2..n, j in 2..n where i != j)(
  pos[i] - pos[j] + (n-1) * (if next[i] == j then 1 else 0 endif) <= n-2
);

% Total travel cost
constraint total_cost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Tour (city -> next): ", show([ i | i in CITIES ]), " -> ", show(next), "\n"
];