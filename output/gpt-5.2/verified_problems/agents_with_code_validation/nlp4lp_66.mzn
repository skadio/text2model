include "globals.mzn";

% Parameters
int: N;                                % Number of towns/cities
int: StartCity;                        % Index of the start city (0-based in .dzn)
array[1..N, 1..N] of int: Distances;   % Symmetric distance matrix (miles)

% Helpful index set
set of int: CITIES = 1..N;

% Convert to 1-based city index for the model
int: START = StartCity + 1;

% Variables
array[CITIES] of var CITIES: succ;     % succ[i] = next city visited after city i
array[CITIES] of var CITIES: pred;     % pred[i] = previous city visited before city i
array[CITIES] of var 1..N: pos;        % position of each city in the tour (for symmetry breaking)

var int: totalDistance;                % Total tour length (sum of traveled distances)

% Constraints

% --- Tour structure: Hamiltonian cycle (single circuit visiting all cities exactly once)
constraint subcircuit(succ);
constraint forall(i in CITIES)(succ[i] != i);  % ensure it is a full circuit (no fixed points)

% --- Channeling between succ and pred (consistency of successor/predecessor views)
constraint inverse(succ, pred);

% --- Fix the start city's position to break rotational symmetry
constraint pos[START] = 1;

% --- Bind positions to the successor relation to make positions represent the tour order.
constraint
  forall(i in CITIES) (
    if pos[i] < N then
      pos[succ[i]] = pos[i] + 1
    else
      succ[i] = START
    endif
  );

% --- Total distance: sum of distances along successor arcs
constraint totalDistance = sum(i in CITIES)(Distances[i, succ[i]]);

% Objective
solve minimize totalDistance;