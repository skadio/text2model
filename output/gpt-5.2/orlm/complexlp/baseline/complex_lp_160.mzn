% Facility Location / Capacitated Distribution Center Problem
% All data embedded as requested.

int: M = 8; % potential distribution centers
int: N = 5; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  3, 3, 5, 4, 3,
  5, 2, 4, 2, 4,
  5, 1, 4, 2, 5,
  4, 1, 1, 3, 3,
  2, 4, 4, 3, 4,
  4, 1, 3, 5, 3,
  5, 1, 2, 4, 1,
  4, 2, 2, 1, 2
]);

array[Stores] of int: demand = [964, 739, 491, 766, 854];

array[Centers] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in Stores)(demand[s]);

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: flow; % units shipped from center c to store s

% Demand satisfaction
constraint forall(s in Stores)(
  sum(c in Centers)(flow[c,s]) = demand[s]
);

% Capacity only if open
constraint forall(c in Centers)(
  sum(s in Stores)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: opening + transportation
var int: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([c | c in Centers where fix(open[c]) = true]), "\n",
  "Flows (center,store,units):\n"
] ++
[
  if fix(flow[c,s]) > 0 then
    "  (" ++ show(c) ++ "," ++ show(s) ++ "," ++ show(fix(flow[c,s])) ++ ")\n"
  else "" endif
  | c in Centers, s in Stores
];