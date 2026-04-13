% Parameters
int: N = 5; % batches
int: M = 3; % vats (machines)

set of int: B = 1..N;
set of int: V = 1..M;

array[B, V] of float: p = 
  [| 3.0, 1.0, 1.0
   | 2.0, 1.5, 1.0
   | 3.0, 1.2, 1.3
   | 2.0, 2.0, 2.0
   | 2.1, 2.0, 3.0 |];

% Upper bound for makespan: sum of all processing times
int: H = ceil(sum(i in B, j in V)(p[i,j]));

% Variables
array[B, V] of var 0..H: s;        % start time of batch i on vat j
array[B, V] of var 0..H: e;        % end time of batch i on vat j
var 0..H: makespan;

% Constraints
constraint
  forall(i in B, j in V) (
    e[i,j] = s[i,j] + ceil(p[i,j])
  );

% Flow-shop precedence within each batch: vat 1 -> vat 2 -> vat 3
constraint
  forall(i in B, j in 1..M-1) (
    s[i,j+1] >= e[i,j]
  );

% No overlap on each vat: batches processed one at a time (unknown order)
constraint
  forall(j in V, i1 in B, i2 in B where i1 < i2) (
    (s[i1,j] >= e[i2,j]) \/ (s[i2,j] >= e[i1,j])
  );

% Makespan definition
constraint
  makespan >= e[N, M];
constraint
  forall(i in B) (makespan >= e[i, M]);

% Objective
solve minimize makespan;