% Max flow from City 0 to City 5 with embedded data

int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

% Capacity matrix (0 means no arc)
array[N, N] of int: cap =
[
| 0,  6,  8,  1,  9,  8 |
|16,  0,  6,  0, 12, 16 |
| 7, 16,  0, 20, 17,  9 |
| 3, 11, 14,  0,  7,  0 |
| 6, 19, 19,  3,  0, 20 |
|20,  5, 16, 12,  2,  0 |
];

% Flow variables on each directed arc
array[N, N] of var 0..max(cap): f;

% Capacity constraints (and force 0 flow where no arc)
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes
constraint forall(v in N where v != s /\ v != t) (
  sum(j in N)(f[v,j]) = sum(i in N)(f[i,v])
);

% Objective: maximize total flow out of source (equivalently into sink)
var int: maxflow = sum(j in N)(f[s,j]);

solve maximize maxflow;

output [
  "Maximum flow (thousand tons/day) = ", show(maxflow), "\n"
];