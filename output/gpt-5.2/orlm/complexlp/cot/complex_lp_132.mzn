% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
%    to:  0  1  2  3  4  5  6  7
   [|  0, 2, 1, 1, 8,17, 6, 7  % from 0
    |  4, 0,14,14,13,19, 4,19  % from 1
    |  6,16, 0, 3,10, 7,18,10  % from 2
    | 19, 4,15, 0, 6, 1,17, 9  % from 3
    | 12,15, 3,14, 0,18,20,14  % from 4
    | 20, 5,19, 9,20, 0,10, 6  % from 5
    |  9,14,12,16,19, 3, 0,10  % from 6
    | 20,16, 6,16, 8,16, 4, 0  % from 7
   |];

int: U = max([cap[i,j] | i in V, j in V]); % upper bound for each arc flow

% Variables
array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): total_flow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation (excluding source and sink)
constraint
  forall(v in V where v != s /\ v != t) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

% Define total flow as net outflow from source (and equivalently net inflow to sink)
constraint
  total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;