% Parameters (with values embedded)
int: N = 6;
set of int: H = 0..N-1;
int: source = 0;
int: sink = 5;

array[H, H] of int: cap =
  array2d(H, H,
  [  0,  7,  8,  1,  2,  4,
    15,  0, 16,  0,  9, 13,
     9,  1,  0,  9, 13, 13,
    10, 11, 19,  0,  1, 12,
    15, 16,  7, 11,  0, 19,
    10, 12, 12, 12, 20,  0 ]);

int: maxCap = max([cap[i,j] | i in H, j in H]);

% Variables
array[H, H] of var 0..maxCap: f;
var 0..(sum(j in H)(cap[source,j])): total_flow;

% Constraints
constraint forall(i in H, j in H) (
  f[i,j] <= cap[i,j]
);

constraint total_flow = sum(j in H)(f[source,j]) - sum(j in H)(f[j,source]);

constraint forall(k in H where k != source /\ k != sink) (
  sum(i in H)(f[i,k]) = sum(j in H)(f[k,j])
);

% Objective
solve maximize total_flow;