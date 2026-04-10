int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 73, 39, 79, 38
 | 73,  0, 30, 46, 29
 | 39, 30,  0, 88, 57
 | 79, 46, 88,  0, 59
 | 38, 29, 57, 59,  0 |];

% Fix a start city to break rotational symmetry (tour cost is invariant to rotation)
int: start = 1;

% succ[i] = next city visited after i
array[CITIES] of var CITIES: succ;

% Miller-Tucker-Zemlin order variables to eliminate subtours
array[CITIES] of var 1..n: ord;

constraint alldifferent(succ);
constraint forall(i in CITIES)(succ[i] != i);

% Set start position
constraint ord[start] = 1;
constraint forall(i in CITIES where i != start)(ord[i] >= 2);

% MTZ subtour elimination:
% for all i != start, j != start, j = succ[i] implies ord[j] = ord[i] + 1 (mod not needed due to fixed start)
% Use inequality form:
constraint forall(i in CITIES where i != start)(
  let { var int: j = succ[i] } in
    ord[j] >= ord[i] + 1
);
% Additionally, ord values are all-different to enforce a single Hamiltonian cycle through the fixed start
constraint alldifferent(ord);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next): ", show(succ), "\n"
];