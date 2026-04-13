% Facility Location / Distribution Planning for SwiftLogistics
% Data embedded as requested.

int: M = 6; % distribution centers
int: N = 8; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];
array[DC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];
array[ST] of int: demand   = [908, 434, 605, 480, 961, 787, 401, 789];

array[DC, ST] of int: transCost =
[| 2, 3, 3, 3, 5, 4, 3, 5
 | 2, 4, 2, 4, 5, 1, 4, 2
 | 5, 4, 1, 1, 3, 3, 2, 4
 | 4, 3, 4, 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1, 4, 2, 2
 | 1, 2, 5, 2, 4, 4, 4, 4
 |];

int: totalDemand = sum(s in ST)(demand[s]);
int: maxTC = max([transCost[d,s] | d in DC, s in ST]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

% Tighten shipping upper bounds to reduce search
constraint forall(d in DC, s in ST)(
  ship[d,s] <= demand[s] * bool2int(open[d])
);

% Demand satisfaction
constraint forall(s in ST)(
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Capacity at each opened distribution center
constraint forall(d in DC)(
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve :: int_search([ship[d,s] | d in DC, s in ST] ++ [bool2int(open[d]) | d in DC],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];