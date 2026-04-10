% Parameters
int: nCities = 5;                           % number of cities
set of int: CITIES = 1..nCities;            % city indices: 1=E,2=F,3=G,4=H,5=I

array[CITIES, CITIES] of int: cost =        % travel cost matrix
  [|  0, 35, 90, 23, 62
   | 35,  0, 53, 58, 46
   | 90, 53,  0, 28, 91
   | 23, 58, 28,  0, 77
   | 62, 46, 91, 77,  0 |];

% Variables
array[CITIES] of var CITIES: succ;          % successor city for each city in the tour
var int: totalCost;                         % total tour cost (including return to start)

% Constraints
% Enforce that 'succ' forms a single Hamiltonian cycle covering all cities.
constraint circuit(succ);

% Sum the travel cost of each directed arc (i -> succ[i]) in the cycle.
constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;