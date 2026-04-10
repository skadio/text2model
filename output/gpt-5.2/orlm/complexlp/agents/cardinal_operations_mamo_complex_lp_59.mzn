% Parameters
% Number of cities (E,F,G,H,I)
int: n = 5;

% City indices (1..5 correspond to E..I)
set of int: CITIES = 1..n;

% Delivery cost matrix (cost[i,j] is cost to go from city i to city j)
% Order: 1=E, 2=F, 3=G, 4=H, 5=I
array[CITIES, CITIES] of int: cost =
[
  %  E   F   G   H   I
  [  0, 50, 48, 99, 91], % E
  [ 50,  0, 57, 84, 72], % F
  [ 48, 57,  0, 46, 86], % G
  [ 99, 84, 46,  0, 29], % H
  [ 91, 72, 86, 29,  0]  % I
];

% Variables
% succ[i] = next city visited after city i (Hamiltonian cycle)
array[CITIES] of var CITIES: succ;

% Total delivery cost of the tour
var int: total_cost;

% Constraints
% Safety: no self-loops (also implied by circuit, but kept explicit)
constraint forall(i in CITIES)(succ[i] != i);

% Hamiltonian cycle: one successor and one predecessor for each city, forming a single cycle
constraint circuit(succ);

% Total tour cost induced by successor mapping
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;