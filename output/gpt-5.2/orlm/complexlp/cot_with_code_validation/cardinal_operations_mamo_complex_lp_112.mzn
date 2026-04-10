% Maximum flow in a directed capacitated network

int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
  0, 0,20,10, 0, 2,11, 5,12,  % from 0
  7, 0, 5, 9, 9,16, 1,17, 7,  % from 1
  3,17, 0, 1, 5,18,13,12,14,  % from 2
  9,10, 2, 0,10,11,11, 5,10,  % from 3
  7, 5, 1,19, 0,19,12,14,15,  % from 4
 16, 4, 6,15,19, 0, 0, 0,20,  % from 5
  3, 0,17,16,19, 8, 0, 8, 9,  % from 6
 14,11,13,17,10,13,20, 0,16,  % from 7
 20, 5,20,16, 0,15, 1,12, 0   % from 8
]);

int: U = sum(i in V, j in V)(cap[i,j]); % safe upper bound on total flow

array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in V, j in V)(f[i,j] <= cap[i,j]);

% No self-flow
constraint forall(i in V)(f[i,i] = 0);

% Flow conservation at intermediate nodes
constraint forall(k in V where k != s /\ k != t)(
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

% Define maxflow as net outflow from source (equivalently net inflow to sink)
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];