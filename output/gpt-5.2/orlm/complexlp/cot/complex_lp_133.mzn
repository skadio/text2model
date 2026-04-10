% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 8;

array[V,V] of int: cap =
% i\j:   0  1  2  3  4  5  6  7  8
[|       0, 6,20,15, 9,20,17,16,20   % 0
 |      11, 0, 4,18,10,12, 3, 7, 8   % 1
 |       5,13, 0, 6,19, 2,14, 9, 4   % 2
 |       7, 8,12, 0, 5,11, 9,10,20   % 3
 |      10, 6, 9,13, 0, 4, 8,15, 7   % 4
 |       3,14, 5, 9,16, 0, 7, 2,12   % 5
 |       9, 4,11, 8, 6,13, 0,10,15   % 6
 |      12, 7, 6,20, 5, 9,14, 0, 8   % 7
 |       6, 5, 7,20, 4,10, 9, 8, 0   % 8
 |];

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V,V] of var 0..maxCap: f;   % flow on arc i->j
var 0..(maxCap*N): totalFlow;

% Constraints
% Respect capacities; also force f[i,i]=0 and f[i,j]=0 when cap[i,j]=0
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(k in V where k != source /\ k != sink) (
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

% Define total flow as net outflow from source (equivalently inflow to sink)
constraint totalFlow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

% Objective
solve maximize totalFlow;