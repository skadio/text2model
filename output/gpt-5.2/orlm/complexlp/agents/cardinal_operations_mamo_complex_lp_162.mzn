% Parameters
int: nCenters = 7;                         % number of potential distribution centers
int: nStores  = 4;                         % number of retail stores

set of int: CENTERS = 1..nCenters;         % index set for centers
set of int: STORES  = 1..nStores;          % index set for stores

array[CENTERS] of int: openCost =          % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost = % transportation cost per unit ($/unit)
  [| 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1
   | 4, 2, 5, 4
   | 1, 1, 3, 3
   | 2, 4, 4, 3
   | 4, 4, 1, 3 |];

array[STORES] of int: demand =             % demand per store (units)
  [884, 420, 566, 673];

array[CENTERS] of int: capacity =          % capacity per center (units)
  [1187, 1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(s in STORES)(demand[s]);  % total demand (units)

% Variables
array[CENTERS] of var bool: open;          % true if center is opened

array[CENTERS, STORES] of var int: ship;   % units shipped from center c to store s

array[STORES] of var int: received;        % total units received by each store
array[CENTERS] of var int: usedSupply;     % total units shipped out of each center

var int: totalOpenCost;                    % sum of opening costs ($)
var int: totalTransCost;                   % sum of transport costs ($)
var int: totalCost;                        % total cost = opening + transport ($)

% Constraints
%--- Nonnegativity / simple bounds (kept as constraints for clarity)
constraint forall(c in CENTERS, s in STORES)(ship[c,s] >= 0);
constraint forall(c in CENTERS)(usedSupply[c] >= 0 /\ usedSupply[c] <= capacity[c]);
constraint forall(s in STORES)(received[s] >= 0 /\ received[s] <= totalDemand);

%--- Linking aggregates
constraint forall(c in CENTERS)(
  usedSupply[c] = sum(s in STORES)(ship[c,s])
);
constraint forall(s in STORES)(
  received[s] = sum(c in CENTERS)(ship[c,s])
);

%--- Capacity only if opened
constraint forall(c in CENTERS)(
  usedSupply[c] <= capacity[c] * bool2int(open[c])
);

%--- Demand satisfaction: each store must receive exactly its demand
constraint forall(s in STORES) (
  received[s] = demand[s]
);

%--- Optional strengthening: total shipped equals total demand (implied by above)
constraint sum(s in STORES)(received[s]) = totalDemand;

%--- Open/ship coupling: no shipments allowed from a closed center
%    (redundant with usedSupply <= capacity*open, but strengthens propagation)
constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] <= demand[s] * bool2int(open[c])
);

%--- Cost expressions
constraint totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
constraint totalTransCost = sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);
constraint totalCost = totalOpenCost + totalTransCost;

% Objective
solve minimize totalCost;