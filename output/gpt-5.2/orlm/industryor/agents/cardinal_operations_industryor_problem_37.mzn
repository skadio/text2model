% Parameters
int: nProducts = 3;              % number of products (jobs)
int: nMachines = 3;              % number of machines

set of int: PRODUCTS = 1..nProducts;
set of int: MACHINES = 1..nMachines;

% Processing times t[product, machine]
array[PRODUCTS, MACHINES] of int: t =
  array2d(PRODUCTS, MACHINES,
    [ 2, 3, 1,   % Product 1: times on machines 1..3
      4, 2, 3,   % Product 2
      3, 5, 2    % Product 3
    ]);

% Variables
array[PRODUCTS] of var PRODUCTS: seq;            % shared processing order (permutation) across all machines
array[PRODUCTS, MACHINES] of var int: start;     % start time of position p on machine m
array[PRODUCTS, MACHINES] of var int: finish;    % finish time of position p on machine m
var int: makespan;                               % completion time of last position on last machine

% Constraints

%----------------------------
% Permutation / sequencing
%----------------------------
constraint
  all_different(seq);

%----------------------------
% Timing definitions
%----------------------------
constraint
  forall(p in PRODUCTS, m in MACHINES) (
    finish[p, m] = start[p, m] + t[seq[p], m]
  );

constraint
  forall(p in PRODUCTS, m in MACHINES) (
    start[p, m] >= 0
  );

%----------------------------
% Machine capacity (no overlap) respecting the shared sequence
%----------------------------
constraint
  forall(m in MACHINES, p in 1..nProducts-1) (
    start[p+1, m] >= finish[p, m]
  );

%----------------------------
% Flow constraints (job precedence across machines)
%----------------------------
constraint
  forall(p in PRODUCTS, m in 1..nMachines-1) (
    start[p, m+1] >= finish[p, m]
  );

%----------------------------
% Makespan definition
%----------------------------
constraint
  makespan = finish[nProducts, nMachines];

% Objective
solve minimize makespan;