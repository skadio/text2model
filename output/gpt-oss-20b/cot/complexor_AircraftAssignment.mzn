% Parameters
int: TotalAircraft;
int: TotalRoutes;
array1d(1..TotalAircraft) of int: Availability;
array1d(1..TotalRoutes) of int: Demand;
array2d(1..TotalAircraft, 1..TotalRoutes) of int: Capacity;
array2d(1..TotalAircraft, 1..TotalRoutes) of int: Costs;

% Variables
array2d(1..TotalAircraft, 1..TotalRoutes) of var 0..1: x;
var int: total_cost;

% Constraints
constraint
  forall(i in 1..TotalAircraft) (
    sum(j in 1..TotalRoutes) x[i][j] <= Availability[i]
  );

constraint
  forall(j in 1..TotalRoutes) (
    sum(i in 1..TotalAircraft) x[i][j] * Capacity[i][j] >= Demand[j]
  );

constraint
  total_cost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes) x[i][j] * Costs[i][j];

constraint
  total_cost >= 0;

% Objective
solve minimize total_cost;