% Parameters
int: nRegions = 6;                         % Number of regions
set of int: REGIONS = 1..nRegions;         % Region index set

array[REGIONS] of int: available = [42, 32, 398, 224, 210, 209];   % Current food (tons)
array[REGIONS] of int: required  = [74, 476, 2, 235, 221, 72];     % Required food (tons)

% Transportation cost per ton from region i to region j (i != j); diagonal set to 0
array[REGIONS, REGIONS] of int: cost =
[
|  0, 16, 48, 42, 50,  8
| 27,  0, 23, 37, 39, 29
| 49, 39,  0, 33, 50,  6
| 23, 49, 46,  0, 50,  6
| 45, 47, 48, 26,  0, 39
| 33, 11,  9,  4, 12,  0
];

% Derived bounds for flow variables
int: totalSupply = sum(r in REGIONS)(available[r]);                % Upper bound on total shipped
int: maxDemand   = max(r in REGIONS)(required[r]);                 % Upper bound on inbound to a region


% Variables
array[REGIONS, REGIONS] of var 0..totalSupply: ship;               % ship[i,j] = tons shipped from i to j
array[REGIONS] of var 0..(totalSupply + maxDemand): finalFood;     % Final food in each region after transfers
var 0..(totalSupply * max(cost)): totalCost;                       % Total transportation cost (bounded)


% Constraints

% No self-shipment (diagonal must be zero)
constraint
  forall(r in REGIONS)(
    ship[r, r] = 0
  );

% Flow conservation / final food balance at each region:
% finalFood[r] = available[r] + inflow(r) - outflow(r)
constraint
  forall(r in REGIONS)(
    finalFood[r] =
      available[r]
      + sum(i in REGIONS where i != r)(ship[i, r])
      - sum(j in REGIONS where j != r)(ship[r, j])
  );

% Demand satisfaction: each region must end with at least its required food
constraint
  forall(r in REGIONS)(
    finalFood[r] >= required[r]
  );

% Total transportation cost computed from all directed shipments
constraint
  totalCost =
    sum(i in REGIONS, j in REGIONS where i != j)(
      ship[i, j] * cost[i, j]
    );


% Objective
solve minimize totalCost;