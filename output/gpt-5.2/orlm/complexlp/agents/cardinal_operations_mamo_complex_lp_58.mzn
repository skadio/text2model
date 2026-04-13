% Parameters
int: n_regions = 5;                               % Number of regions
set of int: R = 1..n_regions;                     % Region index set

array[R] of int: supply = [133, 189, 446, 346, 184];   % Current supply in each region
array[R] of int: demand = [146, 270, 313, 102, 412];   % Required demand in each region

% Transportation cost per unit shipped from region i to region j
array[R, R] of int: cost =
  [|  0, 24, 32, 44, 46
   | 41,  0,  6, 11, 49
   | 40, 10,  0, 40, 45
   | 22, 22, 34,  0,  1
   | 46, 14, 35, 36,  0 |];

% Variables
% x[i,j] = units shipped from region i to region j
array[R, R] of var 0..max(supply): x;

% Total transportation cost (safe upper bound)
var 0..(max(cost) * sum(supply)): total_cost;

% Aggregates for readability
array[R] of var 0..sum(supply): outgoing;         % total shipped out of region i
array[R] of var 0..sum(supply): incoming;         % total shipped into region i

% Constraints

% --- Flow aggregation (define outgoing and incoming from shipment matrix) ---
constraint
  forall(i in R) (
    outgoing[i] = sum(j in R)(x[i,j])
  );

constraint
  forall(j in R) (
    incoming[j] = sum(i in R)(x[i,j])
  );

% --- Supply limits (cannot ship out more than available supply at a region) ---
constraint
  forall(i in R) (
    outgoing[i] <= supply[i]
  );

% --- Demand satisfaction via conservation (final stock at each region meets demand) ---
% Final inventory at region i = supply[i] - outgoing[i] + incoming[i]
constraint
  forall(i in R) (
    supply[i] - outgoing[i] + incoming[i] >= demand[i]
  );

% --- No self-shipment (diagonal costs are 0, but keep explicit) ---
constraint
  forall(i in R) (
    x[i,i] = 0
  );

% --- Total transportation cost definition ---
constraint
  total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;