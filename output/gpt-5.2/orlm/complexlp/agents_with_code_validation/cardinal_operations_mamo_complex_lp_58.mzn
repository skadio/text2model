% Parameters
int: n_regions = 5;                                  % Number of regions
set of int: REGIONS = 1..n_regions;                  % Region index set

array[REGIONS] of int: supply =                      % Current supply in each region
  [133, 189, 446, 346, 184];

array[REGIONS] of int: demand =                      % Required demand in each region
  [146, 270, 313, 102, 412];

array[REGIONS, REGIONS] of int: cost =               % Transport cost per unit from i to j
  [| 0, 24, 32, 44, 46
   | 41, 0,  6, 11, 49
   | 40, 10, 0, 40, 45
   | 22, 22, 34, 0,  1
   | 46, 14, 35, 36, 0 |];

int: total_supply = sum(r in REGIONS)(supply[r]);
int: total_demand = sum(r in REGIONS)(demand[r]);
int: max_ship = total_supply;                        % Safe upper bound for any shipment
int: max_total_cost = max_ship * sum(i,j in REGIONS)(cost[i,j]);  % Conservative upper bound


% Variables
array[REGIONS, REGIONS] of var 0..max_ship: ship;    % Units shipped from region i to region j
var 0..max_total_cost: total_cost;                   % Total transportation cost


% Constraints
% Feasibility: must have enough total supply to meet total demand
constraint total_supply >= total_demand;

% No self-shipping
constraint forall(r in REGIONS)(ship[r,r] = 0);

% Define total cost
constraint total_cost = sum(i,j in REGIONS)(cost[i,j] * ship[i,j]);

% Shipment conservation: outbound shipments from each region cannot exceed its available supply
constraint
  forall(i in REGIONS)(
    sum(j in REGIONS)(ship[i,j]) <= supply[i]
  );

% Demand satisfaction via net flow:
% final_stock[j] = supply[j] + inbound - outbound >= demand[j]
constraint
  forall(j in REGIONS)(
    supply[j] + sum(i in REGIONS)(ship[i,j]) - sum(k in REGIONS)(ship[j,k]) >= demand[j]
  );

% Global balance sanity (redundant but harmless)
constraint
  sum(i in REGIONS)(supply[i]) - sum(j in REGIONS)(demand[j]) >= 0;


% Objective
solve minimize total_cost;