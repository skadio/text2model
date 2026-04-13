% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;

int: source = 0;
int: sink = 8;

array[V, V] of int: cap =
% i -> j capacity (0 means no arc)
[| 0, 0, 20, 10, 0,  2, 11,  5, 12  % from 0
 | 7, 0,  5,  9, 9, 16,  1, 17,  7  % from 1
 | 3,17,  0,  1, 5, 18, 13, 12, 14  % from 2
 | 9,10,  2,  0,10, 11, 11,  5, 10  % from 3
 | 7, 5,  1, 19, 0, 19, 12, 14, 15  % from 4
 |16, 4,  6, 15,19,  0,  0,  0, 20  % from 5
 | 3, 0, 17, 16,19,  8,  0,  8,  9  % from 6
 |14,11, 13, 17,10, 13, 20,  0, 16  % from 7
 |20, 5, 20, 16, 0, 15,  1, 12,  0  % from 8
|];

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;

% Constraints
% Capacity constraints (and enforce no flow where there is no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != source /\ v != sink) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Objective: maximize net flow out of source (equivalently into sink)
var 0..(N * maxCap): total_flow =
  sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

% (Optional but consistent) tie total_flow to sink balance
constraint total_flow =
  sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]);

% Objective
solve maximize total_flow;