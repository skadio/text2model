% Parameters (with values embedded)
int: N = 5;
set of int: SHOPS = 1..N;

array[SHOPS, SHOPS] of int: cost =
 [| 0, 13, 87, 76, 50
  | 13, 0, 15, 65, 85
  | 87, 15, 0, 45, 81
  | 76, 65, 45, 0, 80
  | 50, 85, 81, 80, 0 |];

int: start = 1;

% Variables
array[SHOPS] of var SHOPS: next;          % successor of each shop in the tour
array[SHOPS] of var 1..N: pos;            % position/order to eliminate subtours

var int: total_cost;

% Constraints
constraint forall(i in SHOPS)(next[i] != i);          % no self-loop
constraint all_different(next);                        % each shop has a unique successor

% Fix the start position (symmetry breaking)
constraint pos[start] = 1;

% MTZ subtour elimination (single Hamiltonian cycle)
constraint forall(i in SHOPS where i != start)(
  pos[i] >= 2 /\ pos[i] <= N
);

constraint forall(i,j in SHOPS where i != j /\ i != start /\ j != start)(
  pos[j] >= pos[i] + 1 - N * (if next[i] == j then 0 else 1 endif)
);

% Total travel cost (includes return to start since it's a cycle)
constraint total_cost = sum(i in SHOPS)(cost[i, next[i]]);

% Objective
solve minimize total_cost;

output [
  "Optimal travel cost = ", show(total_cost), "\n",
  "next = ", show(next), "\n"
];