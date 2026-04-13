% Parameters
int: nCities = 4;                         % Number of cities
set of int: CITIES = 1..nCities;          % City index set

array[CITIES, CITIES] of int: cost =      % Travel cost from city i to city j
  [|  0, 26, 49, 75
   | 26,  0, 19, 52
   | 49, 19,  0, 49
   | 75, 52, 49,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;     % x[i,j] = 1 if the tour uses arc i->j
array[CITIES] of var 1..nCities: pos;     % MTZ position of each city in the tour
var int: totalCost;                       % Total travel cost of the tour

% Constraints

% --- Arc selection constraints (each city has exactly one outgoing and one incoming arc) ---
constraint
  forall(i in CITIES) (
    sum(j in CITIES where j != i)(x[i,j]) = 1
  );
constraint
  forall(j in CITIES) (
    sum(i in CITIES where i != j)(x[i,j]) = 1
  );

% --- No self-loops ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- MTZ subtour elimination constraints ---
% Fix a reference city (City 1) to break symmetry and anchor positions
constraint pos[1] = 1;

% Enforce consistent ordering along selected arcs to prevent subtours
constraint
  forall(i in CITIES where i != 1) (
    pos[i] >= 2
  );
constraint
  forall(i in CITIES, j in CITIES where i != j /\ i != 1 /\ j != 1) (
    pos[i] - pos[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Total cost definition ---
constraint
  totalCost =
    sum(i in CITIES, j in CITIES where i != j) (cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;