int: TotalAircraft;
int: TotalRoutes;

array[1..TotalAircraft] of int: Availability;
array[1..TotalRoutes] of int: Demand;

array2d(1..TotalAircraft, 1..TotalRoutes) of int: Capacity;
array2d(1..TotalAircraft, 1..TotalRoutes) of int: Costs;

array[1..TotalAircraft, 1..TotalRoutes] of var 0..maxint: x;

constraint
  forall(i in 1..TotalAircraft) (
    sum(j in 1..TotalRoutes) x[i,j] <= Availability[i]
  );

constraint
  forall(j in 1..TotalRoutes) (
    sum(i in 1..TotalAircraft) Capacity[i,j] * x[i,j] >= Demand[j]
  );

solve minimize
  sum(i in 1..TotalAircraft) sum(j in 1..TotalRoutes) Costs[i,j] * x[i,j];

output [
  "Total Cost: ", show(sum(i in 1..TotalAircraft) sum(j in 1..TotalRoutes) Costs[i,j] * x[i,j]), "\n",
  "Assignments (aircraft x route):\n",
  concat([ show(i), ": ", show([x[i,j] | j in 1..TotalRoutes]), "\n" | i in 1..TotalAircraft ])
];