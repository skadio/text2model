% Parameters
int: nRegions = 7;                             % Number of regions
set of int: REGIONS = 1..nRegions;             % Region index set

array[REGIONS] of int: supply =                % Initial supplies in each region
  [318, 349, 129, 381, 430, 52, 124];

array[REGIONS] of int: demand =                % Required demand in each region
  [309, 9, 279, 71, 365, 233, 483];

array[REGIONS, REGIONS] of int: cost =         % Transport cost per unit from i -> j
  [|  0,  2, 26, 19, 16, 26, 36
   | 27,  0, 26,  4, 15, 43, 25
   | 17, 45,  0, 18, 36, 37, 39
   | 19, 16, 14,  0,  5, 35,  9
   | 44, 47,  4,  3,  0,  2,  4
   | 30, 12, 28, 10, 16,  0, 25
   | 19, 16, 10,  2, 50,  4,  0 |];

int: totalSupply = sum(i in REGIONS)(supply[i]);  % Total supply available
int: totalDemand = sum(i in REGIONS)(demand[i]);  % Total demand required

int: maxCost = max(i in REGIONS, j in REGIONS)(cost[i,j]); % Maximum per-unit transport cost


% Variables
array[REGIONS, REGIONS] of var 0..totalSupply: flow;  % Units shipped from region i to region j (nonnegative)

var 0..(totalSupply * maxCost): totalCost; % Total transport cost (bounded)


% Constraints

% --- Feasibility of overall balance (enough total supply to cover total demand) ---
constraint totalSupply >= totalDemand;

% --- No self-shipment (do not ship from a region to itself) ---
constraint
  forall(i in REGIONS) (
    flow[i,i] = 0
  );

% --- Supply (outbound) capacity: cannot ship out more than initial supply at each region ---
constraint
  forall(i in REGIONS) (
    sum(j in REGIONS)(flow[i,j]) <= supply[i]
  );

% --- Demand satisfaction via net inflow:
% For each region, initial supply + inflow - outflow must meet or exceed its demand.
constraint
  forall(r in REGIONS) (
    supply[r]
    + sum(i in REGIONS)(flow[i,r])
    - sum(j in REGIONS)(flow[r,j])
    >= demand[r]
  );

% --- Define total transportation cost from flows and per-unit costs ---
constraint
  totalCost =
    sum(i in REGIONS, j in REGIONS)(
      flow[i,j] * cost[i,j]
    );


% Objective
solve minimize totalCost;