include "globals.mzn";

% Parameters
int: nCities = 5;
set of int: CITIES = 1..nCities;

array[CITIES, CITIES] of int: cost =
  [|  0, 73, 39, 79, 38
   | 73,  0, 30, 46, 29
   | 39, 30,  0, 88, 57
   | 79, 46, 88,  0, 59
   | 38, 29, 57, 59,  0 |];

% Variables
array[CITIES] of var CITIES: succ;     % successor city
array[CITIES] of var 1..nCities: pos;  % position of each city in the tour
var int: total_cost;

% Constraints

% Each city has exactly one outgoing arc
constraint alldifferent(succ);

% No self-loops
constraint forall(i in CITIES)(succ[i] != i);

% Subtour elimination / single Hamiltonian cycle using positions:
% Fix a start city position to break symmetry
constraint pos[1] = 1;

% If i goes to j and i is not last, then pos[j] = pos[i] + 1
constraint forall(i in CITIES)(
  (pos[i] < nCities) -> (pos[succ[i]] = pos[i] + 1)
);

% If i is last, it must go back to the start (city 1)
constraint forall(i in CITIES)(
  (pos[i] = nCities) -> (succ[i] = 1)
);

% Positions are a permutation (each city appears exactly once in the order)
constraint alldifferent(pos);

% Total cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n",
  "pos = ", show(pos), "\n"
];