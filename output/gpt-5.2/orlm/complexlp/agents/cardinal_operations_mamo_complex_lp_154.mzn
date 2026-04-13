% Parameters
int: nCenters = 6;                       % number of potential distribution centers
int: nStores  = 8;                       % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =        % fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: shipCost =  % transportation cost per unit
[
  % stores:   1  2  3  4  5  6  7  8
             2, 3, 4, 5, 6, 7, 8, 5,   % center 1
             2, 4, 6, 8, 6, 4, 3, 2,   % center 2
             5, 4, 3, 2, 1, 2, 3, 4,   % center 3
             4, 3, 2, 1, 2, 3, 4, 3,   % center 4
             5, 1, 2, 3, 4, 5, 3, 2,   % center 5
             1, 2, 3, 4, 3, 2, 1, 4    % center 6
];

array[STORES] of int: demand =           % demand for each store
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS] of int: capacity =        % supply capacity for each center
  [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;        % open[c] = true iff center c is opened

array[CENTERS, STORES] of var 0..totalDemand: shipQty;
% shipQty[c,s] = units shipped from center c to store s (bounded by total demand)

var 0..intmax: totalCost;                % total cost = opening + shipping

% Constraints
% Per-store shipment upper bound (never exceed demand for a store from any one center)
constraint
  forall(c in CENTERS, s in STORES) (
    shipQty[c,s] <= demand[s]
  );

% Capacity and opening linking: if closed => ship nothing; if open => respect capacity
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(shipQty[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Demand satisfaction: meet each store's demand exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(shipQty[c,s]) = demand[s]
  );

% Link totalCost to opening costs + shipping costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
    + sum(c in CENTERS, s in STORES)(shipCost[c,s] * shipQty[c,s]);

% (Optional strengthening) Total shipped across all centers equals total demand
constraint
  sum(c in CENTERS, s in STORES)(shipQty[c,s]) = totalDemand;

% (Optional strengthening) If any shipment leaves a center, then the center must be open
constraint
  forall(c in CENTERS)(
    (sum(s in STORES)(shipQty[c,s]) > 0) -> open[c]
  );

% Objective
solve minimize totalCost;