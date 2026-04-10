% Parameters
int: nCenters = 8;              % Number of potential distribution centers
int: nStores  = 8;              % Number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =  % Fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transportCost =  % Unit transport cost center->store
  [| 3, 3, 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2, 5, 4
   | 1, 1, 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3, 5, 1
   | 2, 4, 1, 4, 2, 2, 1, 2
   | 5, 2, 4, 4, 4, 4, 5, 3
   | 1, 4, 2, 4, 2, 2, 4, 5
   | 2, 2, 4, 2, 2, 4, 4, 1 |];

array[STORES] of int: demand =   % Demand at each store
  [695, 737, 452, 616, 587, 779, 892, 440];

array[CENTERS] of int: capacity = % Supply capacity of each center
  [1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;  % true if center is opened

% Units shipped from center c to store s (bounded by max store demand for safety)
array[CENTERS, STORES] of var 0..max(demand): ship;

% Cost components and objective
var 0..sum(c in CENTERS)(openCost[c]) : totalOpenCost;                      % Total fixed opening cost
var 0..(max(transportCost) * totalDemand) : totalShipCost;                 % Total transport cost
var 0..(sum(c in CENTERS)(openCost[c]) + max(transportCost) * totalDemand) : totalCost; % Total cost

% Constraints

%-------------------------------
% Demand fulfillment constraints
%-------------------------------
% Each store's demand must be met exactly by shipments from all centers.
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

%--------------------------------
% Capacity and opening constraints
%--------------------------------
% Total shipments out of a center cannot exceed its capacity, and must be zero if not opened.
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

%---------------------------------------
% Total cost component linking constraints
%---------------------------------------
constraint
  totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));

constraint
  totalShipCost = sum(c in CENTERS, s in STORES)(transportCost[c,s] * ship[c,s]);

constraint
  totalCost = totalOpenCost + totalShipCost;

% Objective
solve minimize totalCost;