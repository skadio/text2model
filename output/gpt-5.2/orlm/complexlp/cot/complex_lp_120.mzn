% Parameters (with values embedded)
int: N = 9;
set of int: H = 0..N-1;
int: source = 0;
int: sink = 8;

array[H, H] of int: cap =
[|  0,  4,  7, 15,  4,  7,  2, 10, 12
 |  0,  0, 17,  2,  5,  1, 10, 14,  5
 |  0,  7,  0, 17,  9, 13, 10,  7,  5
 |  0, 16,  4,  0, 11,  9, 12, 18, 12
 |  0,  3,  0, 18,  0,  5,  2,  0, 19
 |  0, 15,  7, 20, 20,  0, 20, 12,  9
 |  0,  8, 14, 13,  1, 17,  0, 10, 19
 |  0,  5,  5, 16,  5,  7,  3,  0, 19
 |  0, 19, 18,  0,  4,  7,  1, 20,  0 |];

int: U = max([cap[i,j] | i in H, j in H]); % upper bound for any single arc flow

% Variables
array[H, H] of var 0..U: f;          % flow on arc i->j
var 0..(sum(j in H) cap[source,j]): total_flow;  % total flow from source to sink

% Constraints
constraint forall(i in H, j in H) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (net outflow - inflow = b[i])
constraint forall(i in H) (
  sum(j in H) f[i,j] - sum(j in H) f[j,i] =
    if i == source then total_flow
    elseif i == sink then -total_flow
    else 0 endif
);

% Objective
solve maximize total_flow;