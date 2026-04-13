include "globals.mzn";

% Parameters
int: n = 5;
set of int: N = 1..n;

% Location indices: 1=E, 2=F, 3=G, 4=H, 5=I
array[N, N] of int: cost = array2d(N, N,
[
  0, 65, 10, 25, 82,
  65, 0, 98, 42, 26,
  10, 98, 0, 75, 72,
  25, 42, 75, 0, 46,
  82, 26, 72, 46, 0
]);

% Variables
array[N] of var N: succ;         % successor of each node in the tour
array[N] of var 1..n: pos;       % position/order variables for MTZ
var int: total_cost;

% Constraints
constraint circuit(succ);

% MTZ subtour elimination (anchor node 1 to break symmetry)
constraint pos[1] = 1;
constraint forall(i in 2..n)(pos[i] >= 2);
constraint forall(i in 2..n, j in 2..n where i != j)(
  pos[i] - pos[j] + (n - 1) * bool2int(succ[i] == j) <= n - 2
);

% Total cost
constraint total_cost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;