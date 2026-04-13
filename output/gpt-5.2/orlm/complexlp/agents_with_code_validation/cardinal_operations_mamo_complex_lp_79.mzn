include "globals.mzn";

% Parameters
int: nCities = 5;                           % Number of cities
set of int: CITIES = 1..nCities;            % City indices (1=A,2=B,3=C,4=D,5=E)

array[CITIES, CITIES] of int: cost =
  [|  0, 44, 19, 92, 71
   | 44,  0, 22, 84, 63
   | 19, 22,  0, 47, 89
   | 92, 84, 47,  0, 78
   | 71, 63, 89, 78,  0 |];

% Variables
array[CITIES] of var CITIES: succ;                 % successor city
array[CITIES] of var 1..nCities: pos;              % position in the tour
var 0..sum(i,j in CITIES)(cost[i,j]): total_cost;  % total tour cost

% Constraints
% Ensure succ defines a single Hamiltonian cycle visiting each city exactly once
constraint circuit(succ);

% Fix a representative tour by anchoring city 1 at position 1 (break rotation symmetry)
constraint pos[1] = 1;

% All positions are distinct
constraint all_different(pos);

% Link successor relation to positions around the cycle (modulo nCities)
constraint forall(i in CITIES)(
  pos[succ[i]] = ((pos[i] mod nCities) + 1)
);

% Total cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n",
  "pos = ", show(pos), "\n"
];