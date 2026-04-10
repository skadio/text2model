% Facility location / transportation model (embedded data)

int: nCenters = 8;
int: nStores  = 8;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  3, 3, 5, 4, 3, 5, 2, 4,
  2, 4, 5, 1, 4, 2, 5, 4,
  1, 1, 3, 3, 2, 4, 4, 3,
  4, 4, 1, 3, 5, 3, 5, 1,
  2, 4, 1, 4, 2, 2, 1, 2,
  5, 2, 4, 4, 4, 4, 5, 3,
  1, 4, 2, 4, 2, 2, 4, 5,
  2, 2, 4, 2, 2, 4, 4, 1
]);

array[Stores] of int: demand = [
  695, 737, 452, 616, 587, 779, 892, 440
];

array[Centers] of int: capacity = [
  1980, 814, 864, 1320, 1952, 1447, 1886, 1962
];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxShipCost = max(c in Centers, s in Stores)(shipCost[c,s]);
int: maxTotalCost = sum(c in Centers)(openCost[c]) + maxShipCost * totalDemand;

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: flow;

% Constraints: meet demand
constraint forall(s in Stores)(
  sum(c in Centers)(flow[c,s]) = demand[s]
);

% Capacity and opening link
constraint forall(c in Centers)(
  sum(s in Stores)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective (direct; avoid defining a separate totalCost var)
solve minimize
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);

output [
  "open = ", show(open), "\n",
  "total_cost = ",
  show(
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s])
  ), "\n"
];