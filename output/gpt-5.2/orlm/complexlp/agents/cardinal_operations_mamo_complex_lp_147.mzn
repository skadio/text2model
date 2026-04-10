% Parameters
int: nCenters = 8;                % number of potential distribution centers
int: nStores  = 9;                % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =  % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: shipCost = % unit transportation cost center->store
  [| 3, 3, 5, 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3, 4, 4, 1
   | 3, 5, 3, 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2, 4, 4, 4
   | 4, 5, 3, 1, 4, 2, 4, 2, 2
   | 4, 5, 2, 2, 4, 2, 2, 4, 4
   | 1, 5, 5, 2, 5, 2, 1, 4, 4 |];

array[STORES] of int: demand =     % demand per store
  [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[CENTERS] of int: capacity =  % supply capacity per center
  [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: totalDemand = sum(s in STORES)(demand[s]);  % upper bound helper

% Variables
array[CENTERS] of var bool: open;                     % true if center is opened
array[CENTERS, STORES] of var 0..totalDemand: ship;   % units shipped center->store

% Conservative upper bound for totalCost (keeps domain finite and consistent)
var 0..(
  sum(c in CENTERS)(openCost[c]) +
  totalDemand * max(c in CENTERS, s in STORES)(shipCost[c,s])
): totalCost;


% Constraints

%--- Demand satisfaction: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

%--- Capacity/opening linking:
%    shipments from a center cannot exceed its capacity and must be 0 if closed
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

%--- Total cost definition: fixed opening costs + variable shipping costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
    + sum(c in CENTERS, s in STORES)(shipCost[c,s] * ship[c,s]);


% Objective
solve minimize totalCost;