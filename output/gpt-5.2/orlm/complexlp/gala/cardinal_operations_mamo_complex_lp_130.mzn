% Max flow from source node 0 to sink node 7 with given arc capacities.
% Data is embedded as required.

include "globals.mzn";

int: n = 8;
set of int: N = 0..n-1;
int: s = 0;
int: t = 7;

% Capacity matrix cap[i,j] (0 means no direct arc)
array[N, N] of int: cap =
[
| 0,  3,  7,  2, 18, 18, 14, 10 |
| 1,  0, 10, 16, 14,  0,  6, 10 |
| 4,  0,  0,  7,  2,  2,  6, 10 |
| 2,  3,  7,  0, 20,  8,  6, 10 |
| 1, 20,  4,  8,  0, 13,  8,  1 |
|16,  9, 17, 17, 11,  0,  7,  8 |
| 3,  7, 14,  1, 20,  5,  0, 13 |
| 3,  6,  5,  1, 14, 20,  9,  0 |
];

% Decision variables: flow on every ordered pair (i,j)
array[N, N] of var 0..max(cap): f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in N, j in N) ( f[i,j] <= cap[i,j] );

% No self-flow
constraint forall(i in N) ( f[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Objective: maximize total flow out of source (= total flow into sink)
var 0..sum(j in N)(cap[s,j]): maxFlow;
constraint maxFlow = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

solve maximize maxFlow;

output [
  "Maximum goods transported (thousands of units) = ", show(maxFlow), "\n",
  "Flow matrix f[i,j]:\n", show(f), "\n"
];