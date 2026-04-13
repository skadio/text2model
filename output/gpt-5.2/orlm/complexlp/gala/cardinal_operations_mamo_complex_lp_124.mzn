include "globals.mzn";

% Max flow from source 0 to sink 8 on a directed network with capacities.
% Data embedded as requested.

int: n = 9;
set of int: N = 0..n-1;
int: s = 0;
int: t = 8;

array[N, N] of int: cap =
  array2d(N, N,
  [
    % from 0
    0,  1, 16,  8, 18,  4,  0,  8,  5,
    % from 1
   15,  0, 11,  8, 13,  2,  1,  7,  6,
    % from 2
   15,  4,  0,  3,  1, 13, 13, 11,  9,
    % from 3
    4, 16,  8,  0, 12, 18, 19,  8, 11,
    % from 4
    4, 19,  3,  2,  0,  6,  1, 13, 14,
    % from 5
    6, 19, 15, 10, 16,  0, 17, 15, 17,
    % from 6
   13,  7, 13,  4, 14,  3,  0,  8,  8,
    % from 7
   10,  6, 19,  1, 12,  6,  9,  0, 14,
    % from 8
    0,  0,  0,  0,  0,  0,  0,  0,  0
  ]);

% Flow variables on each arc (i,j)
array[N, N] of var 0..max(cap): f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i,j in N) (f[i,j] <= cap[i,j]);

% No self-flow
constraint forall(i in N) (f[i,i] = 0);

% Flow conservation for intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Objective: maximize total flow into sink (equivalently out of source)
var 0..sum(j in N)(cap[s,j]): maxFlow = sum(i in N)(f[i,t]);

solve maximize maxFlow;

output [
  "Maximum cargo flow (thousand tons) from city ", show(s), " to city ", show(t), " = ",
  show(maxFlow), "\n\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j==0 then "" else " " endif ++ show(f[i,j]) | j in N ]) ++ "\n" | i in N ])
];