% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;

int: source = 0;
int: sink = 8;

array[V, V] of int: cap =
%      0  1  2  3  4  5  6  7  8
[|    0, 2, 8,17,16,20,15,12, 9  % from 0
 |    4, 0,11, 7, 3,19,10,19, 8  % from 1
 |   14, 7, 0, 7,13,19,18,20, 5  % from 2
 |   17,17, 7, 0,11, 7,17, 0,10  % from 3
 |   20,10, 2,18, 0,15, 8, 6,18  % from 4
 |    4, 9,12, 1,17, 0, 0,13,18  % from 5
 |   12,15,12,19,18,19, 0, 6,17  % from 6
 |   14, 1,17,20,11,20, 6, 0, 4  % from 7
 |   19, 3,19,12, 8,18,17,13, 0  % from 8
 |];

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(N*maxCap): total_flow;

% Constraints
constraint forall(i in V)(f[i,i] = 0);

constraint forall(i in V, j in V)(
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != source /\ v != sink)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define total flow (net outflow of source = net inflow of sink)
constraint total_flow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);
constraint total_flow = sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]);

% Objective
solve maximize total_flow;