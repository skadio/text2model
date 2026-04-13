% Parameters
int: N;                                % Number of cities
int: StartCity;                        % Start city index (may be 0-based or 1-based depending on .dzn)
array[1..N, 1..N] of int: Distances;   % Symmetric distance matrix

set of int: CITIES = 1..N;             % Helpful index set

include "globals.mzn";

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j] = 1 iff tour uses arc i->j
array[CITIES] of var 1..N: succ;               % successor city for each city (circuit representation)
array[CITIES] of var 0..N-1: visitOrder;       % order/position in the tour (for tightening / MTZ)

var 0..(max(i,j in CITIES)(Distances[i,j]) * N): totalDistance;  % bounded total length

% Constraints

% --- Degree constraints ---
% Exactly one outgoing arc from each city.
constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming arc to each city.
constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% No self loops.
constraint forall(i in CITIES) (
  x[i,i] = 0
);

% --- Link x to succ ---
% succ[i] is the unique j such that x[i,j] = 1.
constraint forall(i in CITIES) (
  sum(j in CITIES)(j * x[i,j]) = succ[i]
);

% --- Single Hamiltonian cycle ---
constraint circuit(succ);

% --- Fix start city order (handle 0-based or 1-based StartCity) ---
constraint
  let {
    int: start = if StartCity in CITIES then StartCity else StartCity + 1 endif
  } in
    visitOrder[start] = 0;

% --- MTZ-style tightening constraints ---
constraint forall(i in CITIES, j in CITIES where i != j) (
  visitOrder[j] >= visitOrder[i] + 1 - (N - 1) * (1 - x[i,j])
);

% --- Total distance ---
constraint
  totalDistance = sum(i in CITIES, j in CITIES)(Distances[i,j] * x[i,j]);

% Objective
solve minimize totalDistance;