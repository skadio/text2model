% Parameters
int: nCenters = 5;                    % number of potential distribution centers
int: nStores  = 9;                    % number of retail stores

set of int: CENTERS = 1..nCenters;    % index set for centers
set of int: STORES  = 1..nStores;     % index set for stores

array[CENTERS] of int: openCost =     % fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: transCost =  % per-unit transportation cost
  [| 5, 2, 3, 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3, 5, 1, 2
   | 4, 1, 4, 2, 2, 1, 2, 5, 2 |];

array[STORES] of int: demand =        % demand of each store
  [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[CENTERS] of int: capacity =     % supply capacity of each center
  [1825, 1821, 1365, 1929, 1502];

int: totalDemand = sum(s in STORES)(demand[s]);     % total demand (for bounds)
int: maxCap      = max(c in CENTERS)(capacity[c]);  % max single-center capacity


% Variables
array[CENTERS] of var bool: open;        % open[c] = true if center c is opened
array[CENTERS, STORES] of var int: ship; % ship[c,s] = units shipped from c to s

var int: totalOpenCost;                  % sum of opening costs for opened centers
var int: totalTransCost;                 % sum of transportation costs for all shipments
var int: totalCost;                      % objective = totalOpenCost + totalTransCost


% Constraints
% Nonnegativity of shipments
constraint forall(c in CENTERS, s in STORES)(
  ship[c,s] >= 0
);

% Each store demand must be met exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Center capacity respected, and no shipping unless open
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Additional per-arc upper bound (tightens search)
constraint forall(c in CENTERS, s in STORES)(
  ship[c,s] <= demand[s] * bool2int(open[c])
);

% Define cost components and total cost
constraint totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
constraint totalTransCost = sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);
constraint totalCost = totalOpenCost + totalTransCost;

% Explicit bounds (help some solvers)
constraint totalOpenCost >= 0;
constraint totalOpenCost <= sum(c in CENTERS)(openCost[c]);

constraint totalTransCost >= 0;
constraint totalTransCost <= (max(c in CENTERS, s in STORES)(transCost[c,s])) * totalDemand;

constraint totalCost >= 0;
constraint totalCost <= sum(c in CENTERS)(openCost[c]) +
                        (max(c in CENTERS, s in STORES)(transCost[c,s])) * totalDemand;


% Objective
solve minimize totalCost;