include "globals.mzn";

int: TotalAircraft;                     % Total number of aircraft
int: TotalRoutes;                        % Total number of routes
array[1..TotalAircraft] of int: Availability;  % Maximum number of routes each aircraft can be assigned to
array[1..TotalRoutes] of int: Demand;   % Number of aircraft required for each route
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;  % Capacity matrix
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;     % Cost matrix

% Decision variables: x[i,j] = 1 if aircraft i is assigned to route j, 0 otherwise
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: x;

% Objective: Minimize total cost
var int: totalCost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes)(Costs[i,j] * x[i,j]);
solve minimize totalCost;

% Constraints
% Each route's demand must be satisfied
constraint forall(j in 1..TotalRoutes)(
    sum(i in 1..TotalAircraft)(x[i,j] * Capacity[i,j]) >= Demand[j]
);

% Each aircraft's availability must not be exceeded
constraint forall(i in 1..TotalAircraft)(
    sum(j in 1..TotalRoutes)(x[i,j]) <= Availability[i]
);

% Output
output [ "Total Cost = ", show(totalCost), "\n", 
         "Assignments = ", show(x), "\n" ];