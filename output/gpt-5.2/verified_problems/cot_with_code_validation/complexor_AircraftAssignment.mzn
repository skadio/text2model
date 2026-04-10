% Aircraft Assignment Problem

% Parameters
int: TotalAircraft;
int: TotalRoutes;

array[1..TotalAircraft] of int: Availability;
array[1..TotalRoutes] of int: Demand;

array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;

% Decision variables: 1 if aircraft a is assigned to route r, else 0
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: x;

% Total cost
var int: TotalCost =
  sum(a in 1..TotalAircraft, r in 1..TotalRoutes) (Costs[a, r] * x[a, r]);

% Constraints

% Each aircraft cannot be assigned more times than its availability
constraint
  forall(a in 1..TotalAircraft) (
    sum(r in 1..TotalRoutes) x[a, r] <= Availability[a]
  );

% Each route demand must be met by total provided capacity
constraint
  forall(r in 1..TotalRoutes) (
    sum(a in 1..TotalAircraft) (Capacity[a, r] * x[a, r]) >= Demand[r]
  );

% Objective
solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "x =\n"
] ++
[
  concat([ show(x[a,r]) ++ if r == TotalRoutes then "\n" else " " endif
         | r in 1..TotalRoutes ])
  | a in 1..TotalAircraft
];