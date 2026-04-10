% Parameters
int: nRegions = 6;                                  % number of regions
set of int: REGIONS = 1..nRegions;                  % region index set

array[REGIONS] of int: stock =                      % initial stock in each region
  [319, 281, 247, 237, 29, 453];

array[REGIONS] of int: demand =                     % required amount in each region
  [243, 243, 124, 202, 84, 28];

array[REGIONS, REGIONS] of int: cost =              % transport cost i -> j
  [|  0, 11, 30, 12, 48, 23
   |  1,  0, 27,  9, 26, 13
   | 29,  6,  0, 27, 13, 44
   |  6, 50, 12,  0, 19, 32
   | 26, 13, 29,  2,  0, 24
   |  9, 26,  2, 37, 22,  0 |];

int: totalStock = sum(r in REGIONS)(stock[r]);      % total available resource
int: totalDemand = sum(r in REGIONS)(demand[r]);    % total required resource

% Variables
array[REGIONS, REGIONS] of var 0..max(stock): flow; % units shipped from i to j (nonnegative)
var 0..(max(cost) * totalStock): totalCost;         % total transport cost (bounded)

% Constraints
constraint forall(i in REGIONS)(flow[i,i] = 0);     % no self-shipment

% Feasibility: total supply equals total demand
constraint totalStock = totalDemand;

% Flow conservation at each region:
% initial stock + inflow - outflow = required demand
constraint
  forall(r in REGIONS) (
    stock[r] + sum(i in REGIONS where i != r)(flow[i,r])
             - sum(j in REGIONS where j != r)(flow[r,j])
    = demand[r]
  );

% Define total transport cost from flows and cost matrix
constraint
  totalCost =
    sum(i in REGIONS, j in REGIONS where i != j)(
      cost[i,j] * flow[i,j]
    );

% Objective
solve minimize totalCost;