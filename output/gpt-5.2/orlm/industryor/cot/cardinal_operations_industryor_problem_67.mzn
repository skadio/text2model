% Parameters (with values embedded)
int: m = 2; % coal yards
int: n = 3; % residential areas

set of int: Yards = 1..m;
set of int: Areas = 1..n;

array[Yards] of int: supply_min = [80, 100];     % minimum received per month (tons)
array[Areas] of int: demand = [55, 75, 50];      % required per month (tons)

% distances in km: rows = yards (A,B), cols = areas (1..3)
array[Yards, Areas] of int: dist = array2d(Yards, Areas,
  [ 10,  5,  6,
     4,  8, 15 ]
);

% Variables
array[Yards, Areas] of var int: x; % tons shipped from yard i to area j

% Constraints
constraint forall(i in Yards, j in Areas) (x[i,j] >= 0);

% Meet each area's demand exactly
constraint forall(j in Areas) (
  sum(i in Yards)(x[i,j]) = demand[j]
);

% Each yard ships at least its minimum monthly amount
constraint forall(i in Yards) (
  sum(j in Areas)(x[i,j]) >= supply_min[i]
);

% Objective
solve minimize sum(i in Yards, j in Areas)(dist[i,j] * x[i,j]);