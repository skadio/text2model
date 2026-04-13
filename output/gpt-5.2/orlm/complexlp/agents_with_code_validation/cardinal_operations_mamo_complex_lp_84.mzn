% Parameters
int: nCities = 6;                              % Number of cities
set of int: CITIES = 1..nCities;               % City index set

array[CITIES, CITIES] of int: cost =           % Travel cost matrix (0 on diagonal)
  [|  0, 23, 50, 92, 56, 91
   | 23,  0, 38, 25, 25, 69
   | 50, 38,  0, 66, 51, 76
   | 92, 25, 66,  0, 97, 37
   | 56, 25, 51, 97,  0, 30
   | 91, 69, 76, 37, 30,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]); % Upper bound helper

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 1..nCities: u;            % MTZ order variables
var 0..(nCities * maxCost): totalCost;         % Total travel cost (bounded)

% Constraints

% --- Degree constraints: exactly one outgoing arc from each city ---
constraint
  forall(i in CITIES) (
    sum(j in CITIES where j != i)(x[i,j]) = 1
  );

% --- Degree constraints: exactly one incoming arc to each city ---
constraint
  forall(j in CITIES) (
    sum(i in CITIES where i != j)(x[i,j]) = 1
  );

% --- No self-loops ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- Subtour elimination (MTZ): prevent cycles not covering all cities ---
% Fix an anchor city to break symmetry (city 1 at position 1)
constraint u[1] = 1;

% Enforce ordering constraints for all arcs between non-anchor cities
constraint
  forall(i in CITIES where i != 1, j in CITIES where j != 1 /\ j != i) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Total cost definition ---
constraint
  totalCost =
    sum(i in CITIES, j in CITIES where j != i) (cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;