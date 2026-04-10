% Parameters
int: nCities = 4;                                 % Number of cities
set of int: CITIES = 1..nCities;                  % City index set

array[CITIES, CITIES] of int: cost =              % Travel cost matrix
  [|  0, 94, 34, 87
   | 94,  0, 62, 87
   | 34, 62,  0, 97
   | 87, 87, 97,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;             % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 1..nCities: u;               % MTZ ordering variables for subtour elimination
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;  % Total tour cost (bounded)

% Constraints

% Link total_cost to selected arcs
constraint
  total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Disallow self-loops (no travel from a city to itself)
constraint
  forall(i in CITIES)(
    x[i,i] = 0
  );

% Exactly one outgoing arc from each city
constraint
  forall(i in CITIES)(
    sum(j in CITIES)(x[i,j]) = 1
  );

% Exactly one incoming arc to each city
constraint
  forall(j in CITIES)(
    sum(i in CITIES)(x[i,j]) = 1
  );

% Fix MTZ anchor city order to break symmetry
constraint
  u[1] = 1;

% MTZ subtour elimination constraints (prevent cycles not including all cities)
constraint
  forall(i in 2..nCities, j in 2..nCities where i != j)(
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% Objective
solve minimize total_cost;