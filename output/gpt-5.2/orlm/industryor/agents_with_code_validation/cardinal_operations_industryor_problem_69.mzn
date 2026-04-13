% Parameters
int: nCities = 4;                         % number of cities
set of int: Cities = 1..nCities;          % city index set

array[Cities, Cities] of int: dist =      % distance matrix
 [| 0, 10, 20, 12
  | 10, 0,  5, 10
  | 20, 5,  0,  8
  | 15, 12, 8,  0 |];

% Variables
array[Cities, Cities] of var 0..1: x;     % x[i,j] = 1 if tour goes directly from i to j
array[Cities] of var 1..nCities: u;       % MTZ order variables (position of city i in the tour)
var 0..sum(i in Cities, j in Cities)(dist[i,j]): total_distance;  % total tour length

% Constraints

% Link objective variable to chosen arcs (total tour length)
constraint
  total_distance =
    sum(i in Cities, j in Cities)(dist[i,j] * x[i,j]);

% No self-loops: cannot travel from a city to itself
constraint
  forall(i in Cities)(
    x[i,i] = 0
  );

% Exactly one outgoing arc from each city
constraint
  forall(i in Cities)(
    sum(j in Cities)(x[i,j]) = 1
  );

% Exactly one incoming arc to each city
constraint
  forall(j in Cities)(
    sum(i in Cities)(x[i,j]) = 1
  );

% Subtour elimination (MTZ): prevent multiple disjoint cycles
% Fix start city to break symmetry
constraint u[1] = 1;

constraint
  forall(i in 2..nCities, j in 2..nCities where i != j)(
    u[i] - u[j] + nCities * x[i,j] <= nCities - 1
  );

% Objective
solve minimize total_distance;