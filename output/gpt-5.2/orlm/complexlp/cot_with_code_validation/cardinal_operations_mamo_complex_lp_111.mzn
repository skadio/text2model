% Max flow in a directed capacitated network (8 nodes)
int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
  array2d(V, V, [
    % to:  0  1  2  3  4  5  6  7
          0,19, 4, 1, 9,13, 8,20,  % from 0
         10, 0,12,12, 8,12, 7, 7,  % from 1
         13,11, 0, 8, 4, 1, 2, 3,  % from 2
          4,12,13, 0,18, 6,19, 8,  % from 3
          9,16, 2, 0, 0,14,18, 7,  % from 4
         10,11, 7,11,16, 0,16, 5,  % from 5
         14,11, 9,11, 3,17, 0,19,  % from 6
         12,20, 5,11,10, 4, 6, 0   % from 7
  ]);

int: U = max([cap[i,j] | i in V, j in V]);
int: Fmax = sum(j in V) (cap[s,j]);

% Variables: flow on each arc and total s->t flow
array[V, V] of var 0..U: f;
var 0..Fmax: F;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (all nodes except source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V) (f[i,v]) = sum(j in V) (f[v,j])
);

% Define objective flow as net outflow from s (equivalently net inflow to t)
constraint F = sum(j in V) (f[s,j]) - sum(i in V) (f[i,s]);
constraint F = sum(i in V) (f[i,t]) - sum(j in V) (f[t,j]);

solve maximize F;

output ["Max flow F = ", show(F), "\n"];