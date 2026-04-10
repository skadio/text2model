% Parameters
int: TotalAircraft; % total number of aircraft
int: TotalRoutes;   % total number of routes

set of int: AIRCRAFT = 1..TotalAircraft; % aircraft index set
set of int: ROUTES   = 1..TotalRoutes;   % route index set

array[AIRCRAFT] of int: Availability; % max number of route-assignments allowed for each aircraft
array[ROUTES] of int: Demand;         % demand requirement (passengers) for each route

array[AIRCRAFT, ROUTES] of int: Capacity; % passenger capacity provided by aircraft a on route r
array[AIRCRAFT, ROUTES] of int: Costs;    % cost of assigning aircraft a to route r


% Variables
array[AIRCRAFT, ROUTES] of var 0..1: assign; % 1 if aircraft a is assigned to route r, else 0

array[ROUTES] of var 0..max(Demand): served_demand; % total passengers served on each route (bounded)
array[AIRCRAFT] of var 0..max(Availability): used_assignments; % number of routes assigned to each aircraft (bounded)


% Constraints

% Link: compute how many route-assignments each aircraft is used for
constraint
  forall(a in AIRCRAFT) (
    used_assignments[a] = sum(r in ROUTES)(assign[a, r])
  );

% Aircraft availability: do not exceed the maximum number of assignments per aircraft
constraint
  forall(a in AIRCRAFT) (
    used_assignments[a] <= Availability[a]
  );

% Link: compute served demand per route as total passenger capacity assigned to that route
constraint
  forall(r in ROUTES) (
    served_demand[r] = sum(a in AIRCRAFT)(Capacity[a, r] * assign[a, r])
  );

% Demand satisfaction: each route must have its demand met by assigned aircraft capacity
constraint
  forall(r in ROUTES) (
    served_demand[r] >= Demand[r]
  );


% Objective
solve minimize sum(a in AIRCRAFT, r in ROUTES)(Costs[a, r] * assign[a, r]);