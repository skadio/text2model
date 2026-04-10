% Parameters (with values embedded)
int: N = 5;                      % goods types: 1..5 = A,B,C,D,E
set of int: G = 1..N;

int: cap = 60;                   % max tons per container
int: minload = 18;               % min tons per used container

array[G] of int: qty = [120, 90, 300, 90, 120];                 % available/required units
array[G] of float: wt = [0.5, 1.0, 0.4, 0.6, 0.65];             % tons per unit

int: A = 1; int: B = 2; int: C = 3; int: D = 4; int: E = 5;

int: maxContainers = sum(g in G)(qty[g]);  % safe upper bound

% Variables
array[1..maxContainers, G] of var 0..max(qty): x;  % units of good g in container k
array[1..maxContainers] of var bool: use;          % whether container k is used

% Constraints
% Fulfill all quantities exactly
constraint forall(g in G)(
  sum(k in 1..maxContainers)(x[k,g]) = qty[g]
);

% Link usage to having any load, and enforce min/max tonnage when used
constraint forall(k in 1..maxContainers)(
  (sum(g in G)(x[k,g]) > 0) <-> use[k]
);

% Weight capacity and minimum load (in tons) for used containers
constraint forall(k in 1..maxContainers)(
  sum(g in G)(wt[g] * int2float(x[k,g])) <= int2float(cap) * bool2float(use[k])
);

constraint forall(k in 1..maxContainers)(
  sum(g in G)(wt[g] * int2float(x[k,g])) >= int2float(minload) * bool2float(use[k])
);

% Packaging requirement: if A is loaded in a container, then C >= 1 in that container
constraint forall(k in 1..maxContainers)(
  x[k,A] > 0 -> x[k,C] >= 1
);

% Each used container must load at least 12 units of D
constraint forall(k in 1..maxContainers)(
  x[k,D] >= 12 * bool2int(use[k])
);

% Symmetry breaking: use earlier containers first
constraint forall(k in 1..maxContainers-1)(
  use[k] >= use[k+1]
);

% Objective
solve minimize sum(k in 1..maxContainers)(bool2int(use[k]));