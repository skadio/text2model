% Parameters
% Number of locations/regions
int: n = 5;
set of int: LOC = 1..n;

% Per-car movement cost matrix (cost[i,j] = cost to move 1 car from i to j)
% Costs are given only for i<j; all other pairs are set to 0 (and are disallowed).
array[LOC, LOC] of int: cost =
  array2d(LOC, LOC,
  [
    0, 11, 13, 28,  0,  % from 1 to (1..5)
    0,  0, 18,  8, 46,  % from 2 to (1..5)
    0,  0,  0,  9, 27,  % from 3 to (1..5)
    0,  0,  0,  0, 20,  % from 4 to (1..5)
    0,  0,  0,  0,  0   % from 5 to (1..5)
  ]);

% Current cars at each location
array[LOC] of int: current = [120, 330, 400, 400, 600];

% Needed cars at each location
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% Big-M upper bound on any shipment (safe bound: total cars in system)
int: totalCars = sum(i in LOC)(current[i]);

% Allowed shipment arcs (only i<j where a positive cost is given)
set of (int,int): ARCS =
  { (i,j) | i in LOC, j in LOC where i < j /\ cost[i,j] > 0 };


% Variables
% x[i,j] = number of cars moved from location i to location j
% (only meaningful on ARCS; forced to 0 elsewhere)
array[LOC, LOC] of var 0..totalCars: x;


% Constraints
% Disallow shipments on non-existing arcs (including i>=j and zero-cost entries)
constraint
  forall(i in LOC, j in LOC where not ((i,j) in ARCS)) (
    x[i,j] = 0
  );

% Flow balance at each location: current - out + in = needed
constraint
  forall(k in LOC) (
    current[k]
    - sum((k,j) in ARCS)(x[k,j])      % shipments leaving k
    + sum((i,k) in ARCS)(x[i,k])      % shipments entering k
    = needed[k]
  );


% Objective
solve minimize sum((i,j) in ARCS)(cost[i,j] * x[i,j]);