% Parameters (with values embedded)
int: N = 3; % products
int: M = 3; % machines
set of int: Products = 1..N;
set of int: Machines = 1..M;

array[Products, Machines] of int: t =
 [| 2, 3, 1  % Product 1
  | 4, 2, 3  % Product 2
  | 3, 5, 2  % Product 3
 |];

int: BigM = sum(i in Products, j in Machines)(t[i,j]) + 1;

% Variables
array[Machines, Products] of var Products: seq;          % order on each machine (must be identical)
array[Machines, Products] of var 0..BigM: start;         % start time of k-th job on machine j
array[Machines, Products] of var 0..BigM: finish;        % finish time of k-th job on machine j
var 0..BigM: makespan;

% Constraints
constraint forall(j in Machines)(all_different(seq[j, Products]));
constraint forall(k in Products, j in 2..M)(seq[j,k] = seq[1,k]); % same order on all machines

% Link start/finish with processing times
constraint forall(j in Machines, k in Products)(
  finish[j,k] = start[j,k] + t[seq[j,k], j]
);

% No overlap on each machine (sequential in the chosen order)
constraint forall(j in Machines)(
  start[j,1] = 0
);
constraint forall(j in Machines, k in 2..N)(
  start[j,k] >= finish[j,k-1]
);

% Flow constraints: a job must finish on machine j-1 before starting on machine j
constraint forall(j in 2..M, k in Products)(
  start[j,k] >= finish[j-1,k]
);

% Makespan definition (end of last job on machine 3)
constraint makespan >= finish[M,N];

% Objective
solve minimize makespan;