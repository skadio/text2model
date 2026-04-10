% Max flow in a directed network (cities 0..6), maximize flow from 0 to 6.
% Data is embedded as given in the description.

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

% Capacity matrix cap[i,j] (0 means no direct railway line)
array[V, V] of int: cap =
  array2d(V, V,
  [  0,18000,11000,15000, 2000, 4000,20000,   % from 0
     4000,   0, 6000, 5000,19000,15000,    0, % from 1
    15000,10000,   0, 7000,    0, 7000, 5000, % from 2
    14000, 5000, 3000,   0,10000,15000,19000, % from 3
     2000,11000, 1000,10000,   0,14000, 6000, % from 4
    10000,14000, 6000, 5000, 3000,   0,18000, % from 5
     8000, 1000,11000, 8000, 6000,20000,    0  % from 6
  ]);

% Decision variables: flow on each directed arc
array[V, V] of var 0..max(cap): f;

% Respect arc capacities (and force 0 flow where no arc exists)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net outflow from source (equivalently inflow to sink)
var 0..sum(j in V)(cap[s,j]): maxFlow;
constraint maxFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxFlow;

output [
  "Maximum passengers per day from City ", show(s), " to City ", show(t), " = ",
  show(maxFlow), "\n"
];