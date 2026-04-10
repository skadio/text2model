% Parameters
int: nRegions = 5;                          % Number of regions/locations
set of int: R = 1..nRegions;                % Region index set

array[R] of int: supply = [120, 330, 400, 400, 600];   % Cars currently present at each location
array[R] of int: demand = [150, 200, 600, 200, 400];   % Cars needed at each location

% Cost matrix: cost[i,j] = unit cost to move one car from i to j (0 if i=j or lane not allowed)
array[R, R] of int: cost =
  [|  0,  0, 13, 11, 28
   |  0,  0, 18,  8, 46
   |  0,  0,  0,  9, 27
   |  0,  0,  0,  0, 20
   |  0,  0,  0,  0,  0 |];

% Derived parameter: safe upper bound on any shipment and on total flow
int: maxShip = sum(i in R)(supply[i]);

% Variables
array[R, R] of var 0..maxShip: x;           % x[i,j] = number of cars moved from location i to location j
var 0..(maxShip * max(cost)): total_cost;    % Total transportation cost

% Constraints

% Disallow non-existent lanes / self-shipment (only allow arcs with positive cost)
constraint
  forall(i in R, j in R where cost[i,j] = 0) (
    x[i,j] = 0
  );

% Flow balance: supply - outgoing + incoming = demand (each region ends exactly at its demand)
constraint
  forall(i in R) (
    supply[i]
    - sum(j in R)(x[i,j])          % outgoing from i
    + sum(j in R)(x[j,i])          % incoming to i
    = demand[i]
  );

% Total cost definition
constraint
  total_cost = sum(i in R, j in R) (cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;