% Coal distribution: minimize ton-kilometers

% Parameters
int: m = 2; % coal yards
int: n = 3; % residential areas

set of int: YARDS = 1..m;
set of int: AREAS = 1..n;

array[YARDS] of int: supply_min = [80, 100];
array[AREAS] of int: demand = [55, 75, 50];

array[YARDS, AREAS] of int: dist =
  [| 10,  5,  6
   |  4,  8, 15 |];

% Variables: tons shipped from yard i to area j
array[YARDS, AREAS] of var 0..sum(demand): x;

% Constraints
constraint forall (i in YARDS) (
  sum (j in AREAS) (x[i, j]) >= supply_min[i]
);

constraint forall (j in AREAS) (
  sum (i in YARDS) (x[i, j]) = demand[j]
);

% Objective: minimize ton-kilometers
solve minimize sum (i in YARDS, j in AREAS) (dist[i, j] * x[i, j]);