include "globals.mzn";

% Parameters
int: N = 3; % products
int: M = 3; % machines
set of int: Products = 1..N;
set of int: Machines = 1..M;

array[Products, Machines] of int: t =
  array2d(Products, Machines,
    [ 2, 3, 1,
      4, 2, 3,
      3, 5, 2
    ]);

int: BigM = sum(i in Products, j in Machines)(t[i,j]);

% Decision variables
array[1..N] of var Products: pos;            % position k -> product pos[k]
array[Products, Machines] of var 0..BigM: start;
array[Products, Machines] of var 0..BigM: comp;
var 0..BigM: makespan;

% pos is a permutation of products (single common order for all machines)
constraint all_different(pos);

% Completion times
constraint
  forall(p in Products, m in Machines) (
    comp[p,m] = start[p,m] + t[p,m]
  );

% Flow through machines for each product
constraint
  forall(p in Products, m in 2..M) (
    start[p,m] >= comp[p,m-1]
  );

% Same order on each machine, no overlap between consecutive products in the order
constraint
  forall(m in Machines, k in 1..N-1) (
    start[pos[k+1], m] >= comp[pos[k], m]
  );

% Makespan definition (end of last machine)
constraint
  forall(p in Products) (
    makespan >= comp[p,M]
  );

solve minimize makespan;