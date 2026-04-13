% Parameters (with values embedded)
int: N = 5;                 % batches
int: M = 3;                 % vats (machines)
set of int: Jobs = 1..N;
set of int: Vats = 1..M;

% Processing times in hours (scaled by 10 to avoid decimals)
int: SCALE = 10;
array[Jobs, Vats] of int: p = array2d(Jobs, Vats, [
  30, 10, 10,
  20, 15, 10,
  30, 12, 13,
  20, 20, 20,
  21, 20, 30
]);

% Upper bound on makespan (sum of all processing times)
int: UB = sum(j in Jobs, m in Vats)(p[j,m]);

% Variables
array[Vats, Jobs] of var Jobs: seq;          % job order on each vat
array[Jobs, Vats] of var 0..UB: start;       % start time of job j on vat m
var 0..UB: makespan;

% Constraints
constraint forall(m in Vats) ( all_different(seq[m,]) );

% Same relative order on all vats (permutation flow shop)
constraint forall(m in 1..M-1, k in 1..N) ( seq[m,k] = seq[m+1,k] );

% Technological order: vat 1 -> vat 2 -> vat 3 for each job
constraint forall(j in Jobs, m in 1..M-1) (
  start[j,m+1] >= start[j,m] + p[j,m]
);

% No overlap on each vat according to the sequence
constraint forall(m in Vats, k in 1..N-1) (
  start[seq[m,k+1], m] >= start[seq[m,k], m] + p[seq[m,k], m]
);

% Makespan definition (completion time of last finished job on vat 3)
constraint forall(j in Jobs) (
  makespan >= start[j,M] + p[j,M]
);

% Objective
solve minimize makespan;