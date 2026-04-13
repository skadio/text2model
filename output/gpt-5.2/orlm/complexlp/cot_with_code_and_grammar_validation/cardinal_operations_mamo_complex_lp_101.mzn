% Parameters
int: N = 6;
set of int: H = 0..N-1;
int: source = 0;
int: sink = 5;

array[H, H] of int: cap =
array2d(H, H, [
  % to:   0,  1,  2,  3,  4,  5
         0,  7,  8,  1,  2,  4,  % from 0
        15,  0, 16,  0,  9, 13,  % from 1
         9,  1,  0,  9, 13, 13,  % from 2
        10, 11, 19,  0,  1, 12,  % from 3
        15, 16,  7, 11,  0, 19,  % from 4
        10, 12, 12, 12, 20,  0   % from 5
]);

int: maxCap = max([cap[i,j] | i in H, j in H]);

% Variables
array[H, H] of var 0..maxCap: f;
var 0..(N*maxCap): total_flow;

% Constraints
constraint
  forall(i in H, j in H) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in H where k != source /\ k != sink) (
    sum(j in H)(f[k,j]) = sum(i in H)(f[i,k])
  );

constraint
  total_flow = sum(j in H)(f[source, j]) - sum(i in H)(f[i, source]);

constraint
  total_flow = sum(i in H)(f[i, sink]) - sum(j in H)(f[sink, j]);

% Objective
solve maximize total_flow;