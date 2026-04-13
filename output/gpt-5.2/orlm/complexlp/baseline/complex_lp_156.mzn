% Facility location + transportation (capacitated) with embedded data

int: nCenters = 7;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: shipCost =
[
  % S1 S2 S3 S4 S5 S6
  |  3, 3, 5, 4, 3, 5   % C1
  |  2, 4, 2, 4, 5, 1   % C2
  |  4, 2, 5, 4, 1, 1   % C3
  |  3, 3, 2, 4, 4, 3   % C4
  |  4, 4, 1, 3, 5, 3   % C5
  |  5, 1, 2, 4, 1, 4   % C6
  |  2, 2, 1, 2, 5, 2   % C7
];

array[STORES] of int: demand = [739, 491, 766, 854, 827, 908];
array[CENTERS] of int: capacity = [1575, 834, 1005, 1904, 1825, 1821, 1365];

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: flow; % units shipped from center c to store s

% Bounds for flows
constraint forall(c in CENTERS, s in STORES) (
  flow[c,s] >= 0 /\ flow[c,s] <= demand[s]
);

% Meet each store demand exactly
constraint forall(s in STORES) (
  sum(c in CENTERS)(flow[c,s]) = demand[s]
);

% Respect each center capacity if opened
constraint forall(c in CENTERS) (
  sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: totalOpenCost = sum(c in CENTERS)(openCost[c] * bool2int(open[c]));
var int: totalShipCost = sum(c in CENTERS, s in STORES)(shipCost[c,s] * flow[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Opening cost = ", show(totalOpenCost), "\n",
  "Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers: ", show([c | c in CENTERS where fix(open[c]) = 1]), "\n\n",
  "Flows (center x store):\n"
] ++
[
  "Center " ++ show(c) ++ ": " ++ show([flow[c,s] | s in STORES]) ++ "\n"
  | c in CENTERS
];