% Parameters
int: nRegions = 6;                          % Number of regions
set of int: R = 1..nRegions;               % Region index set

array[R] of int: supply =                  % Initial food supply in each region
  [268, 222, 357, 128, 465, 48];

array[R] of int: demand =                  % Required food amount in each region
  [165, 246, 262, 286, 439, 83];

array[R, R] of int: cost =                 % Transport cost per unit from i to j
  [| 0, 49, 11, 23,  2, 39
   |33,  0, 26,  2,  2, 14
   |12, 31,  0, 36, 30, 34
   |18, 50, 12,  0, 19, 20
   | 3, 13, 20, 29,  0,  1
   | 2,  9, 50, 36, 39,  0 |];

int: total_supply = sum(r in R)(supply[r]); % Total available supply
int: total_demand = sum(r in R)(demand[r]); % Total required demand
int: max_cost = max(i in R, j in R)(cost[i,j]);

% Variables
array[R, R] of var 0..total_supply: x;      % Units shipped from region i to region j
var 0..(total_supply * max_cost): total_cost; % Total transportation cost

% Constraints

% No self-shipment (keep diagonal at 0 to avoid meaningless flows)
constraint forall(r in R) ( x[r, r] = 0 );

% Flow conservation / balance at each region:
% initial supply + inflow - outflow must equal required demand
constraint
  forall(r in R) (
    supply[r]
    + sum(i in R)(x[i, r])
    - sum(j in R)(x[r, j])
    = demand[r]
  );

% Total cost definition (link total_cost to shipment decisions)
constraint
  total_cost = sum(i in R, j in R)(cost[i, j] * x[i, j]);

% Global consistency check: feasible only if total supply equals total demand
constraint total_supply = total_demand;

% Objective
solve minimize total_cost;