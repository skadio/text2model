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
array[AIRCRAFT, ROUTES] of var 0..max(Availability): x;

var int: TotalCost;

% Constraints
constraint forall(a in AIRCRAFT) (
  Availability[a] >= 0
);

constraint forall(r in ROUTES) (
  Demand[r] >= 0
);

constraint forall(a in AIRCRAFT, r in ROUTES) (
  x[a,r] <= Availability[a]
);

constraint forall(a in AIRCRAFT) (
  sum(r in ROUTES)(x[a,r]) <= Availability[a]
);

constraint forall(r in ROUTES) (
  sum(a in AIRCRAFT)(Capacity[a,r] * x[a,r]) >= Demand[r]
);

constraint TotalCost = sum(a in AIRCRAFT, r in ROUTES)(Costs[a,r] * x[a,r]);

% Objective
solve minimize TotalCost;