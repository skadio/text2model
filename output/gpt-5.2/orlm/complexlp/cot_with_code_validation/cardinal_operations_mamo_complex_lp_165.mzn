% BestWay Logistics - Facility location + transportation
% Data embedded as requested

int: N = 6; % distribution centers
int: M = 4; % stores

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: transCost =
[| 2, 3, 3, 3
 | 5, 4, 3, 5
 | 2, 4, 2, 4
 | 5, 1, 4, 2
 | 5, 4, 1, 1
 | 3, 3, 2, 4 |];

array[Stores]  of int: demand   = [589, 962, 966, 643];
array[Centers] of int: capacity = [1631, 1954, 1446, 820, 1640, 966];

int: totalDemand = sum(s in Stores)(demand[s]);

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Total cost (kept as var int without a tight explicit domain to avoid heavy compilation)
var int: totalCost;

% Demand satisfaction
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity only if open
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Cost definition
constraint totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

% Objective type requested: maximization
solve maximize totalCost;

output [show(totalCost)];