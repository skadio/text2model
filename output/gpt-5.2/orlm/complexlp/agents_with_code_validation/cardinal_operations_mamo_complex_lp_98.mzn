% Parameters
int: nCities = 4;                              % Number of cities
set of int: CITIES = 1..nCities;               % City index set

array[CITIES, CITIES] of int: cost =           % Travel cost matrix (diagonal set to 0)
  [|  0, 26, 49, 75
   | 26,  0, 19, 52
   | 49, 19,  0, 49
   | 75, 52, 49,  0 |];

int: startCity = 1;                            % Fixed start city (symmetry reference)


% Variables
array[CITIES] of var CITIES: succ;             % succ[i] = next city visited after i
array[CITIES] of var CITIES: pred;             % pred[i] = previous city visited before i
var int: totalCost;                            % Total tour cost


% Constraints
include "globals.mzn";

% --- Tour structure: each city has one outgoing and one incoming arc ---
constraint alldifferent(succ);
constraint alldifferent(pred);

% --- Disallow self-loops (no city can go to itself) ---
constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

% --- Consistency between successor and predecessor representations ---
constraint forall(i in CITIES)(pred[succ[i]] = i);

% --- Enforce a single Hamiltonian cycle (eliminate subtours) ---
constraint circuit(succ);

% --- Validity of provided start city parameter (and possible symmetry anchor) ---
constraint startCity in CITIES;

% --- Total travel cost accumulation along the chosen successor arcs ---
constraint totalCost >= 0;
constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);


% Objective
solve minimize totalCost;