% Parameters
int: numDC = 6;                        % number of distribution centers
int: numStores = 9;                    % number of retail stores

set of int: DC = 1..numDC;
set of int: Stores = 1..numStores;

array[DC] of int: openCost =           % fixed cost to open each DC
  [151000, 192000, 114000, 171000, 160000, 120000];

array[DC] of int: capacity =           % supply capacity of each DC (units)
  [1795, 1540, 1395, 1730, 1215, 1095];

array[Stores] of int: demand =         % demand of each store (units)
  [401, 523, 610, 709, 835, 742, 955, 688, 574];

array[DC, Stores] of int: transCost =  % transportation cost per unit
  [| 2, 3, 1, 4, 3, 2, 1, 3, 2
   | 4, 2, 3, 1, 2, 3, 2, 1, 4
   | 1, 1, 2, 3, 2, 1, 3, 2, 4
   | 4, 1, 3, 2, 1, 2, 3, 1, 4
   | 1, 4, 2, 3, 2, 3, 1, 2, 4
   | 4, 4, 3, 2, 1, 2, 3, 2, 4 |];

% Derived bounds to keep decision variables bounded
int: totalDemand = sum(s in Stores)(demand[s]);

% Variables
array[DC] of var 0..1: open;                 % 1 if DC is opened, 0 otherwise
array[DC, Stores] of var 0..totalDemand: ship;  % units shipped from DC d to store s

% Constraints

% Demand fulfillment: each store's demand must be met exactly
constraint
  forall(s in Stores) (
    sum(d in DC)(ship[d, s]) = demand[s]
  );

% Capacity and opening linkage: a DC can only ship if opened, and cannot exceed capacity
constraint
  forall(d in DC) (
    sum(s in Stores)(ship[d, s]) <= capacity[d] * open[d]
  );

% Objective
solve minimize
  sum(d in DC)(openCost[d] * open[d]) +
  sum(d in DC, s in Stores)(transCost[d, s] * ship[d, s]);