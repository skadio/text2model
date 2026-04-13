% Facility Location / Capacitated Distribution Center Problem
% All data embedded directly in this model.

int: nCenters = 9;
int: nStores  = 7;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Stores] of int: demand = [
  695, 737, 452, 616, 587, 779, 892
];

array[Centers] of int: capacity = [
  1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962
];

% Transportation cost per unit from each center to each store.
% NOTE: The problem statement does not provide the full 9x7 matrix.
% The matrix below is a placeholder consistent with the "etc." wording.
% Replace with the actual costs to obtain the true optimal total cost.
array[Centers, Stores] of int: shipCost =
[
  % S1 S2 S3 S4 S5 S6 S7
    3, 5, 6, 4, 7, 5, 6,   % Center 1
    2, 4, 5, 3, 6, 4, 5,   % Center 2
    4, 6, 7, 5, 8, 6, 7,   % Center 3
    3, 5, 6, 4, 7, 5, 6,   % Center 4
    5, 7, 8, 6, 9, 7, 8,   % Center 5
    2, 3, 4, 3, 5, 4, 4,   % Center 6
    4, 5, 6, 5, 7, 6, 6,   % Center 7
    3, 4, 5, 4, 6, 5, 5,   % Center 8
    2, 5, 6, 4, 7, 5, 6    % Center 9
];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxShipCost = max(c in Centers, s in Stores)(shipCost[c,s]);
int: maxObj = sum(c in Centers)(openCost[c]) + totalDemand * maxShipCost;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: flow;

% Each store's demand must be met exactly.
constraint forall(s in Stores)(
  sum(c in Centers)(flow[c,s]) = demand[s]
);

% Center capacity cannot be exceeded; if not opened, it ships nothing.
constraint forall(c in Centers)(
  sum(s in Stores)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

var 0..maxObj: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * flow[c,s]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers: ", show([c | c in Centers where fix(open[c]) = true]), "\n"
];