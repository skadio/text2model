% Parameters (with values embedded)
int: n = 6;
set of int: LOC = 1..n;

array[LOC, LOC] of int: cost =
 [|  0, 48, 23, 70, 14, 20
  | 48,  0, 79, 37, 63, 96
  | 23, 79,  0, 40, 66, 68
  | 70, 37, 40,  0, 70, 28
  | 14, 63, 66, 70,  0, 73
  | 20, 96, 68, 28, 73,  0 |];

% Variables
array[LOC] of var LOC: succ;                % successor of each location
array[LOC] of var 0..n-1: ord;              % order variables for MTZ subtour elimination
var int: total_cost;

% Constraints
constraint forall(i in LOC)(succ[i] != i);  % no self-loops
constraint alldifferent(succ);              % each node has a unique successor (permutation)

% MTZ subtour elimination (fix order of node 1 to 0, eliminate subtours)
constraint ord[1] = 0;
constraint forall(i in 2..n)(ord[i] >= 1 /\ ord[i] <= n-1);
constraint forall(i in 2..n, j in 2..n where i != j)(
  ord[i] - ord[j] + n * bool2int(succ[i] == j) <= n-1
);

% Total cost
constraint total_cost = sum(i in LOC)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;