% Parameters (with values embedded)
int: n = 6;
set of int: N = 1..n;

% Locations: 1=A, 2=B, 3=C, 4=D, 5=E, 6=F
array[N, N] of int: cost = array2d(N, N,
[
  0, 77, 89, 19, 31, 62,
  77, 0, 36, 81, 71, 93,
  89, 36, 0, 32, 48, 36,
  19, 81, 32, 0, 98, 82,
  31, 71, 48, 98, 0, 66,
  62, 93, 36, 82, 66, 0
]);

int: cost_lb = 0;
int: cost_ub = max([cost[i,j] | i in N, j in N]);

% Variables
array[N] of var N: succ;              % successor of each location in the tour
array[N] of var 0..(n-1): order;      % for subtour elimination (MTZ-style)
var int: total_cost;

% Constraints
constraint
  forall(i in N)(succ[i] != i);

constraint
  alldifferent(succ);

% MTZ subtour elimination: fix an arbitrary root (1) to break symmetry
constraint order[1] = 0;
constraint forall(i in 2..n)(order[i] >= 1 /\ order[i] <= n-1);

constraint
  forall(i in 2..n, j in 2..n where i != j)(
    order[i] - order[j] + (n-1) * (succ[i] == j) <= n-2
  );

% Total cost of the Hamiltonian cycle
constraint
  total_cost = sum(i in N)(cost[i, succ[i]]);

constraint total_cost >= cost_lb;
constraint total_cost <= n * cost_ub;

% Objective
solve minimize total_cost;