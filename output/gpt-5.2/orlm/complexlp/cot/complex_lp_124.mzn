% Parameters (with values embedded)
int: N = 9;
set of int: Cities = 0..N-1;
int: source = 0;
int: sink = 8;

array[Cities, Cities] of int: cap =
[|  0,  1, 16,  8, 18,  4,  0,  8,  5
 | 15,  0, 11,  8, 13,  2,  1,  7,  6
 | 15,  4,  0,  3,  1, 13, 13, 11,  9
 |  4, 16,  8,  0, 12, 18, 19,  8, 11
 |  4, 19,  3,  2,  0,  6,  1, 13, 14
 |  6, 19, 15, 10, 16,  0, 17, 15, 17
 | 13,  7, 13,  4, 14,  3,  0,  8,  8
 | 10,  6, 19,  1, 12,  6,  9,  0, 14
 |  0,  0,  0,  0,  0,  0,  0,  0,  0
 |];

int: U = sum(i in Cities, j in Cities)(cap[i,j]); % safe upper bound

% Variables
array[Cities, Cities] of var 0..U: f;     % flow on each directed arc
var 0..U: F;                               % total flow from source to sink

% Constraints
constraint forall(i in Cities, j in Cities)(
  f[i,j] <= cap[i,j]
);

constraint forall(v in Cities where v != source /\ v != sink)(
  sum(i in Cities)(f[i,v]) = sum(j in Cities)(f[v,j])
);

constraint F = sum(j in Cities)(f[source,j]) - sum(i in Cities)(f[i,source]);
constraint F = sum(i in Cities)(f[i,sink]) - sum(j in Cities)(f[sink,j]);

% Objective
solve maximize F;