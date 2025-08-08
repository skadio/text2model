include "globals.mzn";

% Data (to be provided via a .dzn file)
int: TotalAircraft;
int: TotalRoutes;
array[1..TotalAircraft] of int: Availability;       % maximum number of routes each aircraft can be assigned to
array[1..TotalRoutes] of int: Demand;                % minimum required capacity for route (demand constraint)
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity; % capacity matrix: passengers that aircraft i can carry on route j
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;    % cost matrix for assigning aircraft i to route j

% Decision variable: assign each route a particular aircraft
array[1..TotalRoutes] of var 1..TotalAircraft: assign;

% For each aircraft, count its assignments. Lower bound is 0 and 
% upper bound is given by the aircraft availability.
array[1..TotalAircraft] of int: lo = [0 | i in 1..TotalAircraft];
array[1..TotalAircraft] of int: up = Availability;

% Constraint: Use global_cardinality_low_up to ensure that each aircraft i is assigned 
% at least lo[i] and at most up[i] times.
constraint global_cardinality_low_up(assign, 1..TotalAircraft, lo, up);

% Constraint: For each route, the capacity of the assigned aircraft must be at least the route's demand.
constraint forall(r in 1..TotalRoutes)(
    Capacity[assign[r], r] >= Demand[r]
);

% Objective: minimize the total cost of assignments.
var int: total_cost = sum(r in 1..TotalRoutes)( Costs[assign[r], r] );
solve minimize total_cost;

% Output the aircraft assignment for each route and the total cost.
output [
    "Assignment per Route: ", show(assign), "\n",
    "Total Cost: ", show(total_cost), "\n"
];