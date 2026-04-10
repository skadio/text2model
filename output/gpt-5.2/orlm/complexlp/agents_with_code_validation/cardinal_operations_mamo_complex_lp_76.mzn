% Parameters
include "globals.mzn";

int: nCities = 5;                         % Number of cities
set of int: CITIES = 1..nCities;          % City indices (1=E, 2=F, 3=G, 4=H, 5=I)

array[CITIES] of string: cityName =       % City names for reference
  ["E","F","G","H","I"];

array[CITIES, CITIES] of int: cost =      % Delivery cost matrix
  [|  0, 31, 19, 71, 74
   | 31,  0, 39, 77, 84
   | 19, 39,  0, 65, 78
   | 71, 77, 65,  0, 38
   | 74, 84, 78, 38,  0 |];

int: maxArcCost = 84;                     % Upper bound on any single arc cost
int: maxTotalCost = nCities * maxArcCost; % Simple upper bound on tour cost


% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after i
array[CITIES] of var CITIES: pred;        % pred[i] = previous city visited before i
array[CITIES] of var 1..nCities: pos;     % MTZ position to eliminate subtours (1..nCities)
var 0..maxTotalCost: totalCost;           % Total tour cost


% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint circuit(succ);

% --- Link predecessor array to successor decisions (ensure consistency) ---
constraint inverse(succ, pred);

% --- No self-loops (redundant with circuit but keeps intent explicit) ---
constraint
  forall(i in CITIES) (
    succ[i] != i /\ pred[i] != i
  );

% --- MTZ subtour elimination using position variables ---
% Choose an arbitrary anchor to break symmetry: city 1 (E) has position 1
constraint pos[1] = 1;

% Positions are all-different (a single Hamiltonian cycle ordering)
constraint all_different(pos);

% MTZ constraints: enforce increasing order along arcs, except those entering the anchor
constraint
  forall(i in CITIES where i != 1) (
    forall(j in CITIES where j != 1 /\ j != i) (
      (succ[i] = j) -> (pos[i] + 1 = pos[j])
    )
  );

% --- Total cost computation: sum cost on each chosen arc i -> succ[i] ---
constraint totalCost = sum(i in CITIES) ( cost[i, succ[i]] );


% Objective
solve minimize totalCost;