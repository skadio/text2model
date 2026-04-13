% Maximum flow from Station 0 (source) to Station 5 (sink)

int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

% Capacity matrix c[u,v] (MW). 0 means no direct connection.
array[V, V] of int: c =
[
| 0,  4, 12, 19, 13, 11 |
|20,  0, 13,  9, 10,  0 |
|14,  8,  0,  5, 13, 11 |
| 5, 15, 18,  0,  6,  7 |
| 8, 17, 20, 14,  0,  9 |
| 9, 19, 19, 11,  4,  0 |
];

% Flow variables on each directed arc
array[V, V] of var 0..max(c): f;

% Capacity constraints (and force zero flow where no arc exists)
constraint
  forall(u in V, v in V) (
    f[u,v] <= c[u,v]
  );

% Flow conservation at intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

% Objective: maximize total flow out of source (equivalently into sink)
var int: maxflow = sum(v in V)(f[s,v]);

solve maximize maxflow;

output [
  "Maximum flow (MW) = ", show(maxflow), "\n"
];