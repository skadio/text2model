include "globals.mzn";

% Max flow on a directed network with 6 nodes (0 = source, 5 = sink).
int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

% Capacities in thousands of vehicles per hour (0 = no arc).
array[N, N] of int: cap =
[
%   0  1  2  3  4  5
    0, 9,13, 0,20,16,   % from 0
    6, 0,19,11,14,15,   % from 1
   11, 6, 0, 8, 3,10,   % from 2
   16, 2,17, 0, 1,17,   % from 3
    4,12, 5,16, 0,15,   % from 4
    7,19,18, 6, 8, 0    % from 5
];

int: U = sum(i in N, j in N)(cap[i,j]); % safe upper bound for flow vars

% Flow on each arc (thousands of vehicles per hour)
array[N, N] of var 0..U: f;

% Capacity constraints (and force 0 flow where no arc exists)
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in N)( f[i,i] = 0 );

% Flow conservation for intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Objective: maximize total flow leaving source (equals entering sink by conservation)
var 0..U: maxflow = sum(j in N)(f[s,j]);
solve maximize maxflow;

output [
  "Maximum flow (thousands of vehicles per hour) = ", show(maxflow), "\n",
  "Flow matrix f[i,j] (thousands):\n", show(f), "\n"
];