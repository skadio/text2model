% Parameters
int: nCenters = 5;                      % number of potential distribution centers
int: nStores  = 5;                      % number of retail stores

set of int: CENTERS = 1..nCenters;      % center indices
set of int: STORES  = 1..nStores;       % store indices

array[CENTERS] of int: openCost =       % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: transCost =  % transportation cost per unit ($)
  [| 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1
   | 1, 3, 3, 2, 4 |];

array[STORES] of int: demand =          % demand per store (units)
  [589, 962, 966, 643, 904];

array[CENTERS] of int: capacity =       % supply capacity per center (units)
  [1954, 1446, 820, 1640, 966];

int: totalDemand = sum(s in STORES)(demand[s]); % total demand (for bounds)


% Variables
array[CENTERS] of var bool: open;        % whether a center is opened

% Units shipped from center c to store s (integer, nonnegative)
array[CENTERS, STORES] of var int: ship;

var int: totalOpenCost;                 % total fixed opening cost
var int: totalTransCost;                % total transportation cost
var int: totalCost;                     % total cost (objective)


% Constraints

% Demand satisfaction: each store must receive exactly its demand
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity / opening linkage: shipments from a center only allowed if it is open,
% and total outbound shipments cannot exceed its capacity when open
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Non-negativity of shipment quantities
constraint
  forall(c in CENTERS, s in STORES)(
    ship[c,s] >= 0
  );

% Cost accounting: compute total fixed opening cost
constraint
  totalOpenCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]));

% Cost accounting: compute total transportation cost
constraint
  totalTransCost =
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

% Cost accounting: total cost is the sum of fixed and transportation costs
constraint
  totalCost = totalOpenCost + totalTransCost;


% Objective
solve minimize totalCost;