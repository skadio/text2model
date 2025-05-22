% Parameters
int: TotalAircraft;
int: TotalRoutes;

set of int: Aircraft = 1..TotalAircraft;
set of int: Routes   = 1..TotalRoutes;

array[Aircraft]                           of int: Availability;
array[Routes]                             of int: Demand;
array[Aircraft, Routes]                   of int: Capacity;
array[Aircraft, Routes]                   of int: Costs;

% Variables
array[Aircraft, Routes] of var 0..1: Assign;

% Constraints
constraint
  forall(a in Aircraft)(
    sum(r in Routes)(Capacity[a,r] * Assign[a,r]) <= Availability[a]
  );

constraint
  forall(r in Routes)(
    sum(a in Aircraft)(Capacity[a,r] * Assign[a,r]) >= Demand[r]
  );

% Objective
var int: TotalCost = sum(a in Aircraft, r in Routes)(Costs[a,r] * Assign[a,r]);

solve minimize TotalCost;