int: TotalAircraft;
int: TotalRoutes;

set of int: AIRCRAFT = 1..TotalAircraft;
set of int: ROUTES = 1..TotalRoutes;

array[AIRCRAFT] of int: Availability;
array[ROUTES] of int: Demand;

array[AIRCRAFT, ROUTES] of int: Capacity;
array[AIRCRAFT, ROUTES] of int: Costs;

% x[a,r] = number of times aircraft a is assigned to route r (integer, can be 0)
array[AIRCRAFT, ROUTES] of var 0..max(Availability): x;

constraint
  forall(a in AIRCRAFT) (
    sum(r in ROUTES)(x[a,r]) <= Availability[a]
  );

% Meet route demand: total carried passengers on each route must be at least Demand[r]
constraint
  forall(r in ROUTES) (
    sum(a in AIRCRAFT)(Capacity[a,r] * x[a,r]) >= Demand[r]
  );

var int: TotalCost = sum(a in AIRCRAFT, r in ROUTES)(Costs[a,r] * x[a,r]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "x = \n",
  concat([ concat([ show(x[a,r]) ++ if r == TotalRoutes then "\n" else " " endif
                  | r in ROUTES ])
          | a in AIRCRAFT ])
];