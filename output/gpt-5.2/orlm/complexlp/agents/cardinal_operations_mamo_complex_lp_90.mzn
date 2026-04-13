% Parameters
int: nCities = 5;                              % number of cities
set of int: CITIES = 1..nCities;               % city indices (1=E, 2=F, 3=G, 4=H, 5=I)

array[CITIES, CITIES] of int: cost =           % delivery cost matrix
  [|  0, 64, 78, 23, 15
   | 64,  0, 15, 44, 93
   | 78, 15,  0, 53, 57
   | 23, 44, 53,  0, 56
   | 15, 93, 57, 56,  0 |];

% Variables
array[CITIES] of var CITIES: succ;             % succ[i] = next city visited after city i
array[CITIES] of var CITIES: pred;             % pred[i] = previous city visited before city i
array[CITIES] of var 1..nCities: pos;          % position of each city in the tour (declared, not required by circuit)

var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;  % total tour cost (bounded)

% Constraints

% 1) Each city has exactly one successor and one predecessor (bijection)
constraint alldifferent(succ);
constraint alldifferent(pred);

% 2) Successor/predecessor consistency: pred is the inverse permutation of succ
constraint inverse(succ, pred);

% 3) No self-loops (a city cannot go to itself)
constraint forall(i in CITIES) ( succ[i] != i );

% 4) Single Hamiltonian cycle (eliminate subtours) using a circuit constraint
constraint circuit(succ);

% 5) Define total tour cost as the sum of arc costs along the successor edges
constraint total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;