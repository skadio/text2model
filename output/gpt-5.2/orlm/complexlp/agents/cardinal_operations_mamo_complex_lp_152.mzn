% Parameters
int: nCenters = 4; % number of potential distribution centers
int: nStores  = 4; % number of retail stores

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000]; % fixed opening cost per center ($)
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];         % supply capacity per center (units)

array[Stores] of int: demand = [859, 713, 421, 652]; % demand per store (units)

array[Centers, Stores] of int: transCost =  % transportation cost per unit ($/unit)
[
| 5, 5, 2, 3
| 3, 3, 5, 4
| 3, 5, 2, 4
| 2, 4, 5, 1
];

int: totalDemand = sum(s in Stores)(demand[s]); % used for shipment upper bounds

% Variables
array[Centers] of var bool: open; % true if distribution center is opened
array[Centers, Stores] of var 0..totalDemand: ship; % units shipped from center c to store s

% Constraints

% Demand satisfaction: each store's total incoming shipment must meet its demand exactly
constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c, s]) = demand[s]
  );

% Capacity and open-linking: a center can only ship if opened, and total shipped cannot exceed capacity
constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

% Optional tightening: if a center is open, it cannot ship more than its capacity (redundant but clear)
constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c, s]) <= capacity[c]
  );

% Objective
solve minimize
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);