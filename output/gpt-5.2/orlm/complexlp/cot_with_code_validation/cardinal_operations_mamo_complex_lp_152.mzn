% Facility location / transportation with fixed opening costs
% Data embedded as required

int: N = 4; % distribution centers
int: M = 4; % retail stores

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000];
array[DC] of int: capacity = [1547, 1656, 1274, 1882];
array[ST] of int: demand   = [859, 713, 421, 652];

array[DC, ST] of int: shipCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

int: totalDemand = sum(s in ST)(demand[s]);
int: maxCap = max(d in DC)(capacity[d]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..maxCap: ship;

% Constraints: satisfy store demands
constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Capacity only if open
constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(shipCost[d,s] * ship[d,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n",
  "ship=\n",
  concat([ concat([ show(ship[d,s]) ++ if s==M then "\n" else " " endif | s in ST]) | d in DC ])
];