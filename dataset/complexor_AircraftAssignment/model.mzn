% ============================================================
% AIRCRAFT ASSIGNMENT OPTIMIZATION MODEL
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% The goal is to assign aircraft to routes in a way that minimizes total assignment cost
% while satisfying the availability of aircraft and the demand for each route.
%
% - Each aircraft has a maximum number of routes it can be assigned to.
% - Each route requires a specific number of aircraft to fulfill passenger demand.
% - Aircraft have different capacities for different routes.
% - Assigning an aircraft to a route incurs a specific cost.
%
% OBJECTIVE:
% ----------
% Determine the optimal assignment of aircraft to routes to **minimize**
% the total cost while ensuring all demand constraints are met.
%
% PARAMETERS PROVIDED IN JSON:
% {
%   "TotalAircraft": <int>, "TotalRoutes": <int>,
%   "Availability": [...], "Demand": [...],
%   "Capacity": [..., ...], "Costs": [..., ...]
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: TotalAircraft;   % Total number of available aircraft
int: TotalRoutes;     % Total number of routes

array[1..TotalAircraft] of int: Availability;
  % Availability[i]: Maximum number of routes an aircraft i can be assigned to

array[1..TotalRoutes] of int: Demand;
  % Demand[j]: Number of aircraft required for route j

array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
  % Capacity[i,j]: Maximum number of passengers aircraft i can carry on route j

array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;
  % Costs[i,j]: Cost of assigning aircraft i to route j


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% Assignment[i, j] = 1 if aircraft i is assigned to route j, 0 otherwise
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: Assignment;

% The total cost of assignments
var int: TotalCost;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Ensure each route meets its demand exactly
constraint
  forall(j in 1..TotalRoutes) (
    sum(i in 1..TotalAircraft)( Assignment[i,j] ) = Demand[j]
  );

% (C2) Ensure that no aircraft is assigned to more routes than it is available for
constraint
  forall(i in 1..TotalAircraft) (
    sum(j in 1..TotalRoutes)( Assignment[i,j] ) <= Availability[i]
  );

% (C3) Ensure aircraft can only be assigned to routes where they have capacity
constraint
  forall(i in 1..TotalAircraft, j in 1..TotalRoutes) (
    Assignment[i,j] * Capacity[i,j] > 0
  );


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

% Calculate total cost of aircraft assignment
constraint
  TotalCost = sum(i in 1..TotalAircraft, j in 1..TotalRoutes)(
    Assignment[i,j] * Costs[i,j]
  );

% Minimize total assignment cost
solve minimize TotalCost;


% -----------------------------
% 5) OUTPUT
% -----------------------------

% Print the optimal assignments and total cost
output [
    "Optimal Aircraft Assignment:\n",
    "  Aircraft-to-Route Assignments:\n",
    forall(i in 1..TotalAircraft) (
        concat([
            "    Aircraft ", show(i), ": ",
            join([show(Assignment[i,j]) | j in 1..TotalRoutes], " "),
            "\n"
        ])
    ),
    "Total Assignment Cost: ", show(TotalCost), "\n"
];
