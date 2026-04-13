% Parameters
include "globals.mzn";

int: n = 6;                              % number of locations
set of int: LOC = 1..n;                  % location index set

array[LOC, LOC] of int: cost =           % delivery cost matrix (diagonal = 0)
  array2d(LOC, LOC,
  [
     0, 48, 23, 70, 14, 20,
    48,  0, 79, 37, 63, 96,
    23, 79,  0, 40, 66, 68,
    70, 37, 40,  0, 70, 28,
    14, 63, 66, 70,  0, 73,
    20, 96, 68, 28, 73,  0
  ]);

int: max_cost = max([cost[i,j] | i in LOC, j in LOC]); % upper bound helper

% Variables
array[LOC] of var LOC: succ;             % succ[i] = next location visited after i
array[LOC] of var LOC: pred;             % pred[i] = previous location visited before i
array[LOC] of var 1..n: pos;             % MTZ ordering variable for subtour elimination
var 0..(n * max_cost): total_cost;       % total route cost (bounded)

% Constraints

% --- Hamiltonian cycle structure (each location has exactly one successor and one predecessor)
constraint
  forall(i in LOC) (
    succ[i] != i /\ pred[i] != i      % forbid self-loops
  );

% Ensure succ is a permutation of locations (all-different successors)
constraint
  alldifferent(succ);

% Ensure pred is a permutation of locations (all-different predecessors)
constraint
  alldifferent(pred);

% Link successor and predecessor arrays to represent the same cycle
constraint
  forall(i in LOC) (
    pred[succ[i]] = i
  );

% --- Subtour elimination (MTZ constraints)
% Use an arbitrary anchor to break symmetry and make MTZ effective
constraint
  pos[1] = 1;

% MTZ: prevent subtours among nodes 2..n
constraint
  forall(i in 2..n, j in 2..n where i != j) (
    (succ[i] = j) -> (pos[i] + 1 = pos[j])
  );

% --- Total cost accumulation
constraint
  total_cost = sum(i in LOC)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;