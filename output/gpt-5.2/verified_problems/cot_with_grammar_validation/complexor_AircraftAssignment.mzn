% Parameters
int: TotalAircraft;
int: TotalRoutes;

set of int: AIRCRAFT = 1..TotalAircraft;
set of int: ROUTES = 1..TotalRoutes;

array[AIRCRAFT] of int: Availability;
array[ROUTES] of int: Demand;

array[AIRCRAFT, ROUTES] of int: Capacity;
array[AIRCRAFT, ROUTES] of int: Costs;

% Variables
array[AIRCRAFT, ROUTES] of var 0..1: Assign;

% Constraints
constraint forall(a in AIRCRAFT) (
  sum(r in ROUTES)(Assign[a,r]) <= Availability[a]
);

constraint forall(r in ROUTES) (
  sum(a in AIRCRAFT)(Capacity[a,r] * Assign[a,r]) >= Demand[r]
);

% Objective
solve minimize sum(a in AIRCRAFT, r in ROUTES)(Costs[a,r] * Assign[a,r]);