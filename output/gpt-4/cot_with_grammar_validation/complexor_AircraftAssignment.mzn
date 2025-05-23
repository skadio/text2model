% Parameters
int: TotalAircraft;
int: TotalRoutes;
array[1..TotalAircraft] of int: Availability;
array[1..TotalRoutes] of int: Demand;
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;

% Variables
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assign;

% Constraints
% Each aircraft cannot be assigned to more routes than its availability
constraint forall(i in 1..TotalAircraft) (
  sum(j in 1..TotalRoutes) (Assign[i,j]) <= Availability[i]
);

% The demand for each route must be met
constraint forall(j in 1..TotalRoutes) (
  sum(i in 1..TotalAircraft) (Assign[i,j] * Capacity[i,j]) >= Demand[j]
);

% Objective
% Minimize the total cost of the assignment
var int: TotalCost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes) (Assign[i,j] * Costs[i,j]);
solve minimize TotalCost;