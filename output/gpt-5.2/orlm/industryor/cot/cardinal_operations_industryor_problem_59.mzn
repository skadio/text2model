% Parameters (with values embedded)
include "globals.mzn";

int: N = 7;
set of int: LOC = 1..N;

array[LOC, LOC] of int: dist =
[|   0,  86,  49,  57,  31,  69,  50
 |  86,   0,  68,  79,  93,  24,   5
 |  49,  68,   0,  16,   7,  72,  67
 |  57,  79,  16,   0,  90,  69,   1
 |  31,  93,   7,  90,   0,  86,  59
 |  69,  24,  72,  69,  86,   0,  81
 |  50,   5,  67,   1,  59,  81,   0
|];

% Variables
array[LOC, LOC] of var 0..1: x;            % x[i,j]=1 if travel directly from i to j
array[LOC] of var 1..N: u;                 % MTZ order variables
var 0..10000: total_distance;

% Constraints
% No self loops
constraint forall(i in LOC)(x[i,i] = 0);

% Exactly one outgoing and one incoming arc for each node
constraint forall(i in LOC)(sum(j in LOC)(x[i,j]) = 1);
constraint forall(j in LOC)(sum(i in LOC)(x[i,j]) = 1);

% Fix start/end at location 1 (still a Hamiltonian cycle; anchors MTZ)
constraint u[1] = 1;
constraint forall(i in 2..N)(u[i] >= 2 /\ u[i] <= N);

% MTZ subtour elimination (for nodes 2..N)
constraint forall(i in 2..N, j in 2..N where i != j)(
  u[i] - u[j] + N * x[i,j] <= N - 1
);

% Objective definition
constraint total_distance = sum(i in LOC, j in LOC)(dist[i,j] * x[i,j]);

% Objective
solve minimize total_distance;