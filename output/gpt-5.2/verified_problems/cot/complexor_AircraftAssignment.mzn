% Parameters
int: TotalAircraft;
int: TotalRoutes;

set of int: AIRCRAFT = 1..TotalAircraft;
set of int: ROUTES   = 1..TotalRoutes;

array[AIRCRAFT] of int: Availability;
array[ROUTES] of int: Demand;

array[AIRCRAFT, ROUTES] of int: Capacity;
array[AIRCRAFT, ROUTES] of int: Costs;

% Variables
array[AIRCRAFT, ROUTES] of var int: Assign;

var int: TotalCost;

% Constraints
constraint forall(a in AIRCRAFT, r in ROUTES) (Assign[a,r] >= 0);

% Aircraft availability: an aircraft cannot be assigned to more routes than allowed
constraint forall(a in AIRCRAFT) (
  sum(r in ROUTES)(Assign[a,r]) <= Availability[a]
);

% Route demand: assigned aircraft on a route must meet required demand
constraint forall(r in ROUTES) (
  sum(a in AIRCRAFT)(Assign[a,r]) >= Demand[r]
);

% Capacity feasibility: assignments must be supportable by aircraft-route capacity
constraint forall(r in ROUTES) (
  sum(a in AIRCRAFT)(Capacity[a,r] * Assign[a,r]) >= Demand[r]
);

% Total cost definition
constraint TotalCost = sum(a in AIRCRAFT, r in ROUTES)(Costs[a,r] * Assign[a,r]);

% Objective
solve minimize TotalCost;