% Parameters
int: nCenters = 7;                      % number of potential distribution centers
int: nStores  = 6;                      % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =       % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost = % unit transport cost ($/unit)
  [| 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2 |];

array[STORES] of int: demand =          % demand per store (units)
  [739, 491, 766, 854, 827, 908];

array[CENTERS] of int: capacity =       % max supply capacity per center (units)
  [1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in STORES)(demand[s]); % used for bounding shipments


% Variables
array[CENTERS] of var bool: open;       % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center c to store s

var 0..sum(c in CENTERS)(openCost[c]) + sum(c in CENTERS, s in STORES)(transCost[c,s] * totalDemand): totalCost;


% Constraints

% Store demand fulfillment: each store must receive exactly its demand
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Center capacity: total shipped from a center cannot exceed its capacity
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c]
  );

% Linking shipments to opening decision: if a center is closed, it ships nothing
% (Using demand[s] as a tight per-arc big-M upper bound.)
constraint
  forall(c in CENTERS, s in STORES)(
    ship[c,s] <= (bool2int(open[c]) * demand[s])
  );

% Total cost definition: opening costs + transportation costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);


% Objective
solve minimize totalCost;