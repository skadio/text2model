include "globals.mzn";

int: NCenters = 4;
int: NStores  = 4;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000];

array[C,S] of int: transpCost =
[
  % Store1 Store2 Store3 Store4
  [   5,     5,     2,     3],   % Center 1
  [   3,     3,     5,     4],   % Center 2
  [   3,     5,     2,     4],   % Center 3
  [   2,     4,     5,     1]    % Center 4
];

array[S] of int: demand = [859, 713, 421, 652];
array[C] of int: capacity = [1547, 1656, 1274, 1882];

% Decision variables
array[C] of var bool: open;
array[C,S] of var 0..max(demand): ship;

% Demand satisfaction
constraint forall(j in S) (
  sum(i in C)(ship[i,j]) = demand[j]
);

% Capacity and linking to opening decision
constraint forall(i in C) (
  sum(j in S)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

var int: totalCost =
  sum(i in C)(openCost[i] * bool2int(open[i])) +
  sum(i in C, j in S)(transpCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([bool2int(open[i]) | i in C]), "\n",
  "Shipments (center x store):\n",
  concat([ concat([ "  c", show(i), " -> s", show(j), ": ", show(ship[i,j]), "\n"
                  | j in S ])
         | i in C ])
];