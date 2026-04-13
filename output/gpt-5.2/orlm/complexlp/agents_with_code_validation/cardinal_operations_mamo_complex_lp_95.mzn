include "globals.mzn";

% Set of locations (4 nodes)
set of int: LOC = 1..4;
% Mapping: E=1, F=2, G=3, H=4

% Delivery cost matrix cost[i,j] = cost to go from location i to location j
array[LOC, LOC] of int: cost =
  [|  0, 62, 51, 50   % E -> (E,F,G,H)
   | 62,  0, 42, 69   % F -> (E,F,G,H)
   | 51, 42,  0, 11   % G -> (E,F,G,H)
   | 50, 69, 11,  0   % H -> (E,F,G,H)
  |];

% Variables
% successor[i] = next location visited immediately after i (Hamiltonian cycle)
array[LOC] of var LOC: successor;

% MTZ-style visit order variables (1..n), with node 1 fixed as root
array[LOC] of var 1..card(LOC): u;

% Total travel cost of the cycle
var 0..sum(i in LOC, j in LOC)(cost[i, j]): total_cost;

% Constraints
% Each node has exactly one successor and one predecessor
constraint all_different(successor);

% Prevent self-loops (i -> i)
constraint forall(i in LOC)(successor[i] != i);

% MTZ subtour elimination
constraint u[1] = 1;
constraint forall(i in LOC where i != 1)(u[i] >= 2 /\ u[i] <= card(LOC));

% Standard MTZ constraints:
constraint forall(i in LOC where i != 1)(
  forall(j in LOC where j != 1 /\ j != i)(
    u[i] - u[j] + card(LOC) * bool2int(successor[i] == j) <= card(LOC) - 1
  )
);

% Total cost accumulation
constraint total_cost = sum(i in LOC)(cost[i, successor[i]]);

% Objective
solve minimize total_cost;