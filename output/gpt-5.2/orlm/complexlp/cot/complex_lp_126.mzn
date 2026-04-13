% Parameters (with values embedded)
int: N = 8;
set of int: H = 0..N-1;

int: source = 0;
int: sink = 7;

array[H, H] of int: cap =
array2d(H, H,
[
  % to: 0  1  2  3  4  5  6  7   <- from row i
      0, 19,  5,  7,  0, 17, 19,  9,  % from 0
      6,  0, 15, 15, 16,  8,  5,  0,  % from 1
      5,  6,  0,  3, 10,  7,  6,  3,  % from 2
      8,  2,  6,  0,  5, 17,  0,  1,  % from 3
     17,  4, 10, 10,  0,  6, 15, 14,  % from 4
     11, 11,  9,  7,  7,  0, 16, 19,  % from 5
     13, 19, 14, 14, 16,  1,  0, 16,  % from 6
      0, 14,  0, 17,  1,  7,  9,  0   % from 7
]);

% Variables
array[H, H] of var 0..19: f;   % upper bound 19 is max capacity in data
var 0..1000: maxflow;

% Constraints
constraint forall(i, j in H) ( f[i,j] <= cap[i,j] );

% Flow conservation (all nodes except source and sink)
constraint forall(k in H where k != source /\ k != sink) (
  sum(i in H)(f[i,k]) = sum(j in H)(f[k,j])
);

% Define total flow value leaving source and entering sink
constraint maxflow = sum(j in H)(f[source,j]) - sum(i in H)(f[i,source]);
constraint maxflow = sum(i in H)(f[i,sink]) - sum(j in H)(f[sink,j]);

% Objective
solve maximize maxflow;