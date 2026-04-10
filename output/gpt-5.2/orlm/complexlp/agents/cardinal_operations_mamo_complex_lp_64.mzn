% Parameters
int: nCities = 6;                           % Number of cities
set of int: CITIES = 1..nCities;            % City index set

array[CITIES, CITIES] of int: cost =        % Travel cost matrix (cost[i,i] = 0)
  array2d(CITIES, CITIES,
  [  0, 65, 41, 14, 16, 35,
    65,  0, 76, 52, 89, 45,
    41, 76,  0, 72, 38, 62,
    14, 52, 72,  0, 22, 24,
    16, 89, 38, 22,  0, 89,
    35, 45, 62, 24, 89,  0 ]);

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]); % For bounding total cost

% Variables
array[CITIES, CITIES] of var 0..1: x;        % x[i,j] = 1 if tour goes directly from i to j
array[CITIES] of var 1..nCities: u;          % MTZ ordering variables to eliminate subtours

var 0..(nCities * maxCost): totalCost;       % Total travel cost of the tour

% Constraints

% --- Arc selection domain restrictions (no self-loops) ---
constraint forall(i in CITIES) ( x[i,i] = 0 );

% --- Exactly one outgoing arc from each city ---
constraint forall(i in CITIES) ( sum(j in CITIES)(x[i,j]) = 1 );

% --- Exactly one incoming arc to each city ---
constraint forall(j in CITIES) ( sum(i in CITIES)(x[i,j]) = 1 );

% --- MTZ subtour elimination constraints (single Hamiltonian cycle) ---
% Fix an anchor city to break symmetry in the ordering
constraint u[1] = 1;

% Enforce ordering for cities 2..nCities to eliminate subtours
constraint
  forall(i in 2..nCities, j in 2..nCities where i != j) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Total cost definition ---
constraint totalCost = sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;