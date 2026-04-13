% Parameters
% Number of locations
int: n = 5;

% Location indices (1..n correspond to E,F,G,H,I respectively)
set of int: LOC = 1..n;

% Delivery cost matrix cost[i,j] = cost to go from location i to location j
% Diagonal entries are set to 0 (not used in the tour).
array[LOC, LOC] of int: cost =
[
  %   E   F   G   H   I
  |  0, 65, 10, 25, 82  % E
  | 65,  0, 98, 42, 26  % F
  | 10, 98,  0, 75, 72  % G
  | 25, 42, 75,  0, 46  % H
  | 82, 26, 72, 46,  0  % I
];

% Variables
% next[i] = the next location visited after i in the tour
array[LOC] of var LOC: next;

% Total delivery cost of the tour
var 0..sum(i in LOC, j in LOC)(cost[i,j]): total_cost;

% Constraints
% 1) Tour structure: each location has exactly one successor and one predecessor
%    (i.e., next is a permutation of all locations)
constraint alldifferent(next);

% 2) Single Hamiltonian cycle: forbid multiple disjoint cycles (subtours)
constraint circuit(next);

% 3) Total cost accumulation: sum cost of each chosen arc i -> next[i]
constraint total_cost = sum(i in LOC)(cost[i, next[i]]);

% Objective
solve minimize total_cost;