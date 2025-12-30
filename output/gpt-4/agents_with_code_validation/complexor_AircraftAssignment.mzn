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

% Constraint 1: Each aircraft cannot be assigned to more routes than its availability
forall(i in 1..TotalAircraft) (
    sum(j in 1..TotalRoutes) (Assignment[i,j]) <= Availability[i]
)

% Constraint 2: The total capacity of aircraft assigned to each route must meet the demand
forall(j in 1..TotalRoutes) (
    sum(i in 1..TotalAircraft) (Assignment[i,j] * Capacity[i,j]) >= Demand[j]
)

% Constraint 3: The assignment of aircraft to routes must be binary (either 0 or 1)
forall(i in 1..TotalAircraft, j in 1..TotalRoutes) (
    Assignment[i,j] in 0..1
)

% Constraint 4: The cost of assigning each aircraft to each route must be non-negative
forall(i in 1..TotalAircraft, j in 1..TotalRoutes) (
    Costs[i,j] >= 0
)

% Objective
solve minimize sum(i in 1..TotalAircraft, j in 1..TotalRoutes) (Assignment[i,j] * Costs[i,j]);