include "globals.mzn";

/* ----- Input data ----- */
int: TotalAircraft;
int: TotalRoutes;
array[1..TotalAircraft] of int: Availability;      % max routes per aircraft
array[1..TotalRoutes]   of int: Demand;           % passengers required per route
array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity;
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;

/* ----- Decision variables ----- */
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: x;   % 1 if aircraft i flies route j

/* ----- Constraints ----- */
% Each aircraft can be used on at most its availability number of routes
constraint forall(i in 1..TotalAircraft)(
    sum(j in 1..TotalRoutes) x[i,j] <= Availability[i]
);

% Each route must receive enough passenger capacity to meet its demand
constraint forall(j in 1..TotalRoutes)(
    sum(i in 1..TotalAircraft) Capacity[i,j] * x[i,j] >= Demand[j]
);

/* ----- Objective ----- */
var int: total_cost = sum([ Costs[i,j] * x[i,j] | i in 1..TotalAircraft, j in 1..TotalRoutes ]);
solve minimize total_cost;

/* ----- Output ----- */
output [
    "Total Cost: ", show(total_cost), "\n",
    "Assignments per aircraft:\n",
    concat([ "  Aircraft ", show(i), ": ", show([ j | j in 1..TotalRoutes where x[i,j] == 1 ]), "\n"
            | i in 1..TotalAircraft ])
];