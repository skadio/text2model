% Parameters
int: nCities = 6;                                  % Number of cities
set of int: CITIES = 1..nCities;                   % City indices

array[CITIES, CITIES] of int: cost =               % Travel cost matrix
  [|  0, 65, 41, 14, 16, 35
   | 65,  0, 76, 52, 89, 45
   | 41, 76,  0, 72, 38, 62
   | 14, 52, 72,  0, 22, 24
   | 16, 89, 38, 22,  0, 89
   | 35, 45, 62, 24, 89,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]); % Upper bound helper

% Variables
array[CITIES, CITIES] of var 0..1: x;              % x[i,j]=1 if travel goes directly from i to j
array[CITIES] of var 1..nCities: u;                % MTZ order variables (subtour elimination)
var 0..(nCities * maxCost): totalCost;             % Total tour cost (bounded)

% Constraints

% --- No self-loops (cannot travel from a city to itself)
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- Exactly one outgoing arc from each city
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(x[i,j]) = 1
  );

% --- Exactly one incoming arc to each city
constraint
  forall(j in CITIES) (
    sum(i in CITIES)(x[i,j]) = 1
  );

% --- MTZ subtour elimination constraints (prevent cycles not including all cities)
% u are position/order variables; enforce ordering for all i != j excluding city 1 as anchor
constraint
  forall(i in 2..nCities, j in 2..nCities where i != j) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Fix anchor city order to break symmetry (choose city 1 as reference)
constraint
  u[1] = 1;

% --- Total cost accumulation
constraint
  totalCost = sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;