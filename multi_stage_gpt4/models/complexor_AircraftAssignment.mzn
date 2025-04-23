% Parameters
int: TotalAircraft; % Total number of aircraft available for assignment
int: TotalRoutes; % Total number of routes that require aircraft assignment
array[1..TotalAircraft] of int: Availability; % The availability of each aircraft
array[1..TotalRoutes] of int: Demand; % The demand for each route
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity; % The capacity of each aircraft for each route
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs; % The cost of assigning each aircraft to each route

% Variables
% The assignment matrix representing the assignment of each aircraft to each route
% If Assignment[i,j] = 1, then aircraft i is assigned to route j. Otherwise, it is not assigned.
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assignment;

% Constraints

% Each aircraft cannot be assigned to more routes than its availability
constraint forall(i in 1..TotalAircraft)(
  sum(j in 1..TotalRoutes)(Assignment[i,j]) <= Availability[i]
);

% The demand for each route must be met
constraint forall(j in 1..TotalRoutes)(
  sum(i in 1..TotalAircraft)(Assignment[i,j] * Capacity[i,j]) >= Demand[j]
);

% The assignment of an aircraft to a route must be feasible
% If the capacity of an aircraft for a route is less than the demand, it cannot be assigned to that route
constraint forall(i in 1..TotalAircraft, j in 1..TotalRoutes)(
  if Capacity[i,j] < Demand[j] then Assignment[i,j] = 0 endif
);

% Objective
% Minimize the total cost of assigning aircraft to routes
solve minimize sum(i in 1..TotalAircraft, j in 1..TotalRoutes)(Assignment[i,j] * Costs[i,j]);