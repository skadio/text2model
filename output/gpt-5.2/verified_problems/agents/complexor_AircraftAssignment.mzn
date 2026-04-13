% Parameters
int: TotalAircraft; % total number of aircraft
int: TotalRoutes;   % total number of routes

set of int: AIRCRAFT = 1..TotalAircraft; % aircraft index set
set of int: ROUTES   = 1..TotalRoutes;   % route index set

array[AIRCRAFT] of int: Availability; % maximum number of routes each aircraft can be assigned to
array[ROUTES] of int: Demand;         % demand requirement for each route

array[AIRCRAFT, ROUTES] of int: Capacity; % passengers that fit for each aircraft-route pair
array[AIRCRAFT, ROUTES] of int: Costs;    % cost of assigning aircraft to route


% Variables
array[AIRCRAFT, ROUTES] of var 0..1: assign; % 1 if aircraft a is assigned to route r, else 0

array[AIRCRAFT] of var int: routes_used;       % number of routes assigned to each aircraft
array[ROUTES] of var int: capacity_served;     % total capacity served on each route


% Constraints
% Link routes_used to assignment decisions (count routes per aircraft)
constraint
  forall(a in AIRCRAFT) (
    routes_used[a] = sum(r in ROUTES)(assign[a,r])
  );

% Aircraft availability limits (each aircraft cannot be used on more routes than allowed)
constraint
  forall(a in AIRCRAFT) (
    routes_used[a] <= Availability[a]
  );

% Link capacity_served to assignment decisions and capacities (total capacity provided per route)
constraint
  forall(r in ROUTES) (
    capacity_served[r] = sum(a in AIRCRAFT)(Capacity[a,r] * assign[a,r])
  );

% Demand satisfaction (each route must receive enough capacity to meet demand)
constraint
  forall(r in ROUTES) (
    capacity_served[r] >= Demand[r]
  );


% Objective
solve minimize sum(a in AIRCRAFT, r in ROUTES)(Costs[a,r] * assign[a,r]);