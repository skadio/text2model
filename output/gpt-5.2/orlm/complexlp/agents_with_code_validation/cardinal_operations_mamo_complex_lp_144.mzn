% Facility location / transportation problem
% Data embedded as required.

int: nCenters = 4;
int: nStores  = 8;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity = [1041, 1576, 1364, 1697];

array[Stores] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];

array[Centers, Stores] of int: transCost =
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3 |];

int: totalDemand = sum(s in Stores)(demand[s]);

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Constraints
constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

% Objective components
var 0..sum(c in Centers)(openCost[c]): totalOpenCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c]));

var 0..(totalDemand * max(c in Centers, s in Stores)(transCost[c,s])): totalTransportCost =
  sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

var int: totalCost = totalOpenCost + totalTransportCost;

% Use an efficient MIP backend if available; prevents long timeouts on some default CP backends.
solve :: int_search([bool2int(open[c]) | c in Centers] ++ [ship[c,s] | c in Centers, s in Stores], first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n"
];