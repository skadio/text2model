include "globals.mzn";

% Parameters
int: TotalAircraft;
int: TotalRoutes;
array[1..TotalAircraft] of int: Availability;
array[1..TotalRoutes] of int: Demand;
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;

% Decision Variables
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assign;

% Objective
var int: total_cost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes) (Assign[i,j] * Costs[i,j]);
minimize total_cost;

% Constraints
constraint forall(i in 1..TotalAircraft) (sum(j in 1..TotalRoutes) (Assign[i,j]) <= Availability[i]);
constraint forall(j in 1..TotalRoutes) (sum(i in 1..TotalAircraft) (Assign[i,j] * Capacity[i,j]) >= Demand[j]);

solve satisfy;
output [ "Total Cost: " ++ show(total_cost) ++ "\n" ] ++
[ if fix(Assign[i,j]) = 1 then "Aircraft " ++ show(i) ++ " is assigned to Route " ++ show(j) ++ "\n" else "" endif | i in 1..TotalAircraft, j in 1..TotalRoutes ];