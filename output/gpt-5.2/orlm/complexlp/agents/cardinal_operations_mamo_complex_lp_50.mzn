% Parameters
int: n_regions = 6;                              % number of regions
set of int: REGIONS = 1..n_regions;              % region index set

array[REGIONS] of int: supply =                  % initial food units available in each region
  [268, 222, 357, 128, 465, 48];

array[REGIONS] of int: demand =                  % required food units needed in each region
  [165, 246, 262, 286, 439, 83];

array[REGIONS, REGIONS] of int: cost =           % transportation cost per unit from i to j
  [|  0, 49, 11, 23,  2, 39
   | 33,  0, 26,  2,  2, 14
   | 12, 31,  0, 36, 30, 34
   | 18, 50, 12,  0, 19, 20
   |  3, 13, 20, 29,  0,  1
   |  2,  9, 50, 36, 39,  0 |];

% Variables
array[REGIONS, REGIONS] of var 0..max(supply): flow;   % units shipped from region i to region j
var 0..(max(cost) * sum(supply)): total_cost;          % total transportation cost

% Constraints

%--------------------------------------------------------------------
% No self-shipment: forbid sending flow from a region to itself
%--------------------------------------------------------------------
constraint
  forall(i in REGIONS) (
    flow[i,i] = 0
  );

%--------------------------------------------------------------------
% Supply (outflow) limits: total shipped out of each region
% cannot exceed its available supply
%--------------------------------------------------------------------
constraint
  forall(i in REGIONS) (
    sum(j in REGIONS) (flow[i,j]) <= supply[i]
  );

%--------------------------------------------------------------------
% Demand satisfaction via net balance:
% initial supply + inflow - outflow >= demand
% (equivalently: net_inflow >= demand - supply)
%--------------------------------------------------------------------
constraint
  forall(r in REGIONS) (
    supply[r] + sum(i in REGIONS) (flow[i,r]) - sum(j in REGIONS) (flow[r,j]) >= demand[r]
  );

%--------------------------------------------------------------------
% Total cost definition: sum of shipped units times per-unit transport cost
%--------------------------------------------------------------------
constraint
  total_cost = sum(i in REGIONS, j in REGIONS) (flow[i,j] * cost[i,j]);

% Objective
solve minimize total_cost;