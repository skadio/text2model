include "globals.mzn";

% Parameters
int: TotalAircraft; % Total number of aircraft
int: TotalRoutes; % Total number of routes
array[1..TotalAircraft] of int: Availability; % Availability of each aircraft
array[1..TotalRoutes] of int: Demand; % Demand for each route
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity; % Capacity of each aircraft for each route
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs; % Cost of assigning each aircraft to each route

% Variables
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assign; % Assignment of aircraft to routes

% Constraints
constraint forall(i in 1..TotalAircraft)(sum(j in 1..TotalRoutes)(Assign[i,j]) <= Availability[i]); % Aircraft availability constraint
constraint forall(j in 1..TotalRoutes)(sum(i in 1..TotalAircraft)(Assign[i,j]*Capacity[i,j]) >= Demand[j]); % Route demand constraint

% Objective
var int: TotalCost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes)(Assign[i,j]*Costs[i,j]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Assignments:"] ++
[if fix(Assign[i,j]) = 1 then "Aircraft " ++ show(i) ++ " is assigned to Route " ++ show(j) ++ "\n" else "" endif | i in 1..TotalAircraft, j in 1..TotalRoutes];