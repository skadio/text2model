% Parameters
include "globals.mzn";

int: nWarehouses = 5;                              % Number of warehouses/cities
set of int: W = 1..nWarehouses;                    % Warehouse index set: 1=A, 2=B, 3=C, 4=D, 5=E

array[W, W] of int: travelCost =                   % Travel cost matrix (diagonal unused/0)
  [|  0, 15, 88, 54, 92
   | 15,  0, 29, 98, 33
   | 88, 29,  0, 96, 96
   | 54, 98, 96,  0, 63
   | 92, 33, 96, 63,  0 |];

% Variables
array[W] of var W: next;                           % next[i] = warehouse visited immediately after i
array[W] of var W: prev;                           % prev[i] = warehouse visited immediately before i
array[W] of var 0..nWarehouses-1: pos;             % position/order of each warehouse in the tour (subtour elimination)
var 0..1000: totalCost;                            % Total travel cost (bounded conservatively)

% Constraints

% --- Tour structure: each warehouse has exactly one successor and one predecessor ---
constraint all_different(next);                    % permutation of successors
constraint all_different(prev);                    % permutation of predecessors

% --- Link next and prev to be inverse permutations (consistent directed cycle edges) ---
constraint inverse(next, prev);

% --- No self-loops (do not travel from a warehouse to itself) ---
constraint forall(i in W) ( next[i] != i /\ prev[i] != i );

% --- Subtour elimination / single Hamiltonian cycle using anchored ordering ---
% Fix a reference warehouse (1 = A) to break symmetry and anchor positions.
constraint pos[1] = 0;

% All other warehouses must have positions 1..nWarehouses-1
constraint forall(i in W where i != 1) (
  pos[i] >= 1 /\ pos[i] <= nWarehouses - 1
);

% Positions form a permutation (unique order for each warehouse)
constraint all_different(pos);

% Enforce order consistency along arcs to eliminate subtours.
% For i != 1, successor must be the next position in the cycle.
constraint forall(i in W where i != 1) (
  pos[next[i]] = (pos[i] + 1) mod nWarehouses
);

% Anchored transitions for warehouse 1
constraint pos[next[1]] = 1;
constraint pos[prev[1]] = nWarehouses - 1;

% --- Total travel cost definition ---
constraint totalCost = sum(i in W)( travelCost[i, next[i]] );

% Objective
solve minimize totalCost;