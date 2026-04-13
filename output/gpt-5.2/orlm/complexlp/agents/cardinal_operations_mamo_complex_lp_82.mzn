% Parameters
int: nCities = 4;                          % Number of cities
set of int: CITIES = 1..nCities;           % City indices: 1=Alpha, 2=Bravo, 3=Charlie, 4=Delta

array[CITIES, CITIES] of int: cost =       % Delivery cost matrix (0 on diagonal)
  [|  0, 41, 55, 22
   | 41,  0, 47, 47
   | 55, 47,  0, 35
   | 22, 47, 35,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;      % x[i,j]=1 if the tour goes directly from city i to city j
array[CITIES] of var 1..nCities: u;        % MTZ order variables for subtour elimination
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): totalCost;  % Total tour cost (bounded)

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

% --- No self-loops (disallow i -> i) ---
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

% --- MTZ subtour elimination constraints (prevent cycles not including all cities) ---
% Fix one city as reference to break symmetry
constraint
  u[1] = 1;

% Bound the order variables for other cities
constraint
  forall(i in CITIES where i != 1) (
    u[i] >= 2 /\ u[i] <= nCities
  );

% MTZ constraints: for all arcs i->j among non-reference cities
constraint
  forall(i in CITIES where i != 1, j in CITIES where j != 1 /\ j != i) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% --- Define total tour cost ---
constraint
  totalCost =
    sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;