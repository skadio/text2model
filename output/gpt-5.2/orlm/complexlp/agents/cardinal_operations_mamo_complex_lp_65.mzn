% Parameters
int: nCities = 6;                         % number of cities
set of int: CITIES = 1..nCities;          % city indices

array[CITIES, CITIES] of int: cost =      % travel cost matrix
  [|  0, 86, 81, 64, 65, 24
   | 86,  0, 44, 80, 91, 23
   | 81, 44,  0, 15, 25, 89
   | 64, 80, 15,  0, 89, 41
   | 65, 91, 25, 89,  0, 29
   | 24, 23, 89, 41, 29,  0
  |];

int: startCity = 1;                       % fixed start/end city

% Variables
array[CITIES] of var CITIES: next;        % successor representation of the tour
var 0..sum(i,j in CITIES)(cost[i,j]): totalCost; % total tour cost (upper-bounded)

% Constraints
% --- Hamiltonian tour structure ---
% Enforce a single Hamiltonian cycle visiting every city exactly once
constraint circuit(next);

% --- Symmetry breaking / fixed start city ---
% Prevent trivial self-loop at the designated start city (helps fix a representative tour)
constraint next[startCity] != startCity;

% --- Total travel cost computation ---
% Sum the arc costs induced by the successor representation
constraint totalCost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize totalCost;