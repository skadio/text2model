% Parameters
include "globals.mzn";

int: nCities = 6;                            % number of cities
set of int: Cities = 1..nCities;             % city indices

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[Cities, Cities] of int: cost =
  [|  0, 49, 34, 18, 62, 14
   | 49,  0, 35, 24, 57, 17
   | 34, 35,  0, 20, 34, 58
   | 18, 24, 20,  0, 47, 45
   | 62, 57, 34, 47,  0, 71
   | 14, 17, 58, 45, 71,  0
  |];

int: startCity = 1;                          % fixed start/end city (tour is a cycle)

int: maxArcCost = max([cost[i,j] | i in Cities, j in Cities]);
int: upperBoundTourCost = nCities * maxArcCost;

% Variables
array[Cities] of var Cities: succ;           % succ[i] = next city visited after city i
var 0..upperBoundTourCost: totalCost;        % total travel cost of the tour


% Constraints

%-------------------------------
% Hamiltonian tour structure
%-------------------------------

% Each city has exactly one successor and each city is successor of exactly one city
% (i.e., succ is a permutation of Cities)
constraint
  all_different(succ);

% No self-loops: cannot go from a city to itself
constraint
  forall(i in Cities) (
    succ[i] != i
  );

% Enforce a single cycle visiting all cities (subtour elimination)
constraint
  subcircuit(succ);

%-------------------------------
% Start/end city handling
%-------------------------------
% The tour is a cycle, so it implicitly starts/ends at every city, including startCity.
% Optional symmetry breaking (leave commented unless desired):
% constraint succ[startCity] > startCity;

%-------------------------------
% Cost accumulation
%-------------------------------

% Total cost equals sum of costs on selected arcs i -> succ[i]
constraint
  totalCost = sum(i in Cities) ( cost[i, succ[i]] );


% Objective
solve minimize totalCost;