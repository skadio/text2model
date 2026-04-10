% Parameters
include "globals.mzn";

int: nCities = 5;                              % Number of cities
set of int: Cities = 1..nCities;               % City index set

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[Cities, Cities] of int: cost =
  [|  0, 82, 76, 92, 59
   | 82,  0, 98, 58, 82
   | 76, 98,  0, 26, 74
   | 92, 58, 26,  0, 96
   | 59, 82, 74, 96,  0 |];

% Simple bounds for tour cost (used to bound totalCost)
int: minArcCost = min([cost[i,j] | i in Cities, j in Cities where i != j]);
int: maxArcCost = max([cost[i,j] | i in Cities, j in Cities where i != j]);
int: minTourCost = nCities * minArcCost;
int: maxTourCost = nCities * maxArcCost;

% Variables
array[Cities] of var Cities: next;             % next[i] = city visited immediately after i
array[Cities] of var Cities: prev;             % prev[j] = city visited immediately before j
array[Cities] of var 1..nCities: pos;          % pos[i] = position of city i in the tour (1..nCities)
var minTourCost..maxTourCost: totalCost;       % Total travel cost of the Hamiltonian cycle

% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint all_different(next);                % permutation => one successor per city, all distinct
constraint all_different(prev);                % permutation => one predecessor per city, all distinct

% --- Consistency between next and prev (they are inverse permutations) ---
constraint forall(i in Cities) (
  prev[next[i]] = i
);

% --- No self-loops (cannot go from a city to itself) ---
constraint forall(i in Cities) (
  next[i] != i
);

% --- Position variables define a single Hamiltonian cycle (subtour elimination) ---
% Fix an arbitrary anchor to break rotational symmetry
constraint pos[1] = 1;

% Follow the tour order using positions: successor has position +1 (mod nCities)
constraint forall(i in Cities) (
  pos[next[i]] = (pos[i] mod nCities) + 1
);

% Positions are a permutation of 1..nCities
constraint all_different(pos);

% --- Total cost accumulation ---
constraint totalCost = sum(i in Cities)( cost[i, next[i]] );

% Objective
solve minimize totalCost;