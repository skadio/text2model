% Parameters
int: nCities = 5;                                  % number of cities
set of int: CITIES = 1..nCities;                   % city indices

array[CITIES, CITIES] of int: cost =               % travel cost matrix
  [|  0, 28, 89, 59, 41
   | 28,  0, 85, 12, 68
   | 89, 85,  0, 22, 70
   | 59, 12, 22,  0, 48
   | 41, 68, 70, 48,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;              % x[i,j] = 1 if travel directly i -> j
array[CITIES] of var CITIES: succ;                 % successor city for each city (tour representation)
var int: totalCost;                                % total travel cost of the tour

% Constraints

% Link arc decision variables x with successor representation succ
constraint
  forall(i in CITIES, j in CITIES) (
    x[i,j] = bool2int(succ[i] = j)
  );

% Each city has exactly one outgoing arc (redundant but strengthens the model)
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(x[i,j]) = 1
  );

% Each city has exactly one incoming arc (redundant but strengthens the model)
constraint
  forall(j in CITIES) (
    sum(i in CITIES)(x[i,j]) = 1
  );

% Disallow self-loops (i -> i)
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% Ensure a single Hamiltonian cycle visiting all cities exactly once
constraint
  circuit(succ);

% Compute total travel cost from selected arcs
constraint
  totalCost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;