include "globals.mzn";

%========================
% Input data (from .dzn)
%========================
int: TotalAircraft;
int: TotalRoutes;

array[1..TotalAircraft] of int: Availability;                 % max assignments per aircraft
array[1..TotalRoutes] of int: Demand;                         % required passenger demand per route

array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;     % passengers carried if aircraft a is assigned to route r
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;        % cost of assigning aircraft a to route r

%========================
% Decision variables
%========================
% x[a,r] = number of times aircraft a is assigned to route r (integer, >= 0)
array[1..TotalAircraft, 1..TotalRoutes] of var 0..max(Availability): x;

%========================
% Constraints
%========================

% Aircraft availability: each aircraft cannot be used more than its availability
constraint
  forall(a in 1..TotalAircraft) (
    sum(r in 1..TotalRoutes)(x[a,r]) <= Availability[a]
  );

% Route demand: total passenger capacity assigned to the route must meet demand
constraint
  forall(r in 1..TotalRoutes) (
    sum(a in 1..TotalAircraft)(x[a,r] * Capacity[a,r]) >= Demand[r]
  );

%========================
% Objective
%========================
var int: TotalCost = sum(a in 1..TotalAircraft, r in 1..TotalRoutes)(x[a,r] * Costs[a,r]);

solve minimize TotalCost;

%========================
% Output
%========================
output [
  "TotalCost = ", show(TotalCost), "\n",
  "x (assignments per aircraft-route) =\n",
  show2d(x), "\n"
];