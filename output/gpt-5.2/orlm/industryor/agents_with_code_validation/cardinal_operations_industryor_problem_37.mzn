include "globals.mzn";

% Parameters
int: nProducts = 3;                 % Number of products (jobs)
int: nMachines = 3;                 % Number of machines
set of int: PRODUCTS = 1..nProducts;
set of int: MACHINES  = 1..nMachines;

array[PRODUCTS, MACHINES] of int: t =
  [| 2, 3, 1   % Product 1 on machines 1..3
   | 4, 2, 3   % Product 2 on machines 1..3
   | 3, 5, 2   % Product 3 on machines 1..3
  |];

int: bigM = sum(i in PRODUCTS, j in MACHINES)(t[i,j]); % Upper bound for times

% Variables
array[PRODUCTS, MACHINES] of var 0..bigM: start;  % Start time of product i on machine j
array[PRODUCTS, MACHINES] of var 0..bigM: finish; % Finish time of product i on machine j
var 0..bigM: makespan;                             % Total processing cycle time (Cmax)

array[1..nProducts] of var PRODUCTS: seq;          % Permutation: processing order of products

% Constraints

% finish time equals start time plus processing duration
constraint
  forall(i in PRODUCTS, j in MACHINES) (
    finish[i,j] = start[i,j] + t[i,j]
  );

% Technological order within each product: machine 1 -> machine 2 -> machine 3
constraint
  forall(i in PRODUCTS, j in 1..nMachines-1) (
    start[i, j+1] >= finish[i, j]
  );

% Sequence variable forms a permutation of products (same order on all machines)
constraint
  all_different(seq);

% No overlap on each machine following the common sequence
constraint
  forall(j in MACHINES, k in 1..nProducts-1) (
    start[seq[k+1], j] >= finish[seq[k], j]
  );

% Makespan definition
constraint
  forall(i in PRODUCTS, j in MACHINES) (
    makespan >= finish[i,j]
  );

% Objective
solve minimize makespan;

% Optional output
output [
  "makespan=", show(makespan), "\n",
  "seq=", show(seq), "\n",
  "start=\n", show(start), "\n",
  "finish=\n", show(finish), "\n"
];