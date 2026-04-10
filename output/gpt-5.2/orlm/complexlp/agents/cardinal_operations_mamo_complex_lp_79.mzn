% Parameters
int: nCities = 5;                               % Number of cities
set of int: CITIES = 1..nCities;                % City indices (1=A,2=B,3=C,4=D,5=E)

array[CITIES, CITIES] of int: cost =            % Travel cost matrix
[|  0, 44, 19, 92, 71
 | 44,  0, 22, 84, 63
 | 19, 22,  0, 47, 89
 | 92, 84, 47,  0, 78
 | 71, 63, 89, 78,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);  % Upper bound per arc

% Variables
array[CITIES, CITIES] of var 0..1: x;           % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 1..nCities: u;             % MTZ ordering variables for subtour elimination
var 0..(nCities * maxCost): totalCost;          % Total travel cost (bounded)

% Constraints

%------------------------------------------------------------
% No self-loops: cannot travel from a city to itself
%------------------------------------------------------------
constraint
  forall(i in CITIES) (
    x[i,i] = 0
  );

%------------------------------------------------------------
% Degree constraints: exactly one outgoing and one incoming arc per city
% (ensures each city is visited exactly once)
%------------------------------------------------------------
constraint
  forall(i in CITIES) (
    sum(j in CITIES)(x[i,j]) = 1
  );

constraint
  forall(j in CITIES) (
    sum(i in CITIES)(x[i,j]) = 1
  );

%------------------------------------------------------------
% Subtour elimination (MTZ constraints)
% Fix one city as reference to break symmetry and anchor the MTZ ordering
%------------------------------------------------------------
constraint
  u[1] = 1;

constraint
  forall(i in 2..nCities) (
    u[i] >= 2
  );

% MTZ: prevent subtours among nodes 2..nCities
constraint
  forall(i in 2..nCities, j in 2..nCities where i != j) (
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

%------------------------------------------------------------
% Total cost definition: sum of costs on selected arcs
%------------------------------------------------------------
constraint
  totalCost = sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;