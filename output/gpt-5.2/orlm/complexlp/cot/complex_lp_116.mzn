% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..8;
int: s = 0;
int: t = 8;

% Capacity matrix c[i,j] (TB/hour). 0 means no direct pathway.
array[V,V] of int: c =
[| 0,11,11,14, 6,11, 4,15, 9
 | 0, 0, 1, 1, 4, 3, 8, 6, 6
 | 0,18, 0,11,10,18, 6,16, 6
 | 0,19, 8, 0, 1, 3, 4, 1, 8
 | 0,15, 3, 4, 0, 5, 2, 7, 3
 | 0,18, 4,18, 6, 0, 9,10,12
 | 0, 1, 7, 8,10, 5, 0, 1,10
 | 0,11, 2, 1,13, 7, 8, 0,16
 | 0,12, 9, 9,18, 8, 1, 9, 0 |];

int: maxCap = 20;

% Variables
array[V,V] of var 0..maxCap: f;        % flow on arc (i->j)
var 0..1000: total_flow;               % value of s-t flow

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= c[i,j]
);

% Flow conservation for intermediate nodes (all except s and t)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define total flow as net outflow from source (equivalently, net inflow to sink)
constraint total_flow =
  sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Ensure sink balance matches total_flow
constraint total_flow =
  sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;