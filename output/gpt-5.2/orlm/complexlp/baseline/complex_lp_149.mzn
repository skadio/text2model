int: F = 6;  % distribution centers
int: S = 9;  % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[STO] of int: demand = [401, 789, 965, 505, 876, 801, 955, 561, 601];

array[FAC] of int: capacity = [1795, 1069, 1615, 1255, 1816, 1095];

% Transportation costs per unit from each center to each store.
% The problem statement says "and so on" / "similar patterns" but does not provide
% complete numeric data for centers 2..6 to all stores. A full matrix is required.
% Please replace the placeholder matrix below with the actual costs.
array[FAC, STO] of int: transCost =
[
  % Stores:   1  2  3  4  5  6  7  8  9
            |2, 3, 2, 3, 2, 3, 2, 3, 2|,  % Center 1 (given pattern)
            |4, 2, 4, 2, 4, 2, 4, 2, 4|,  % Center 2 (given pattern)
            |3, 4, 3, 4, 3, 4, 3, 4, 3|,  % Center 3 (PLACEHOLDER)
            |5, 3, 5, 3, 5, 3, 5, 3, 5|,  % Center 4 (PLACEHOLDER)
            |2, 5, 2, 5, 2, 5, 2, 5, 2|,  % Center 5 (PLACEHOLDER)
            |4, 4, 4, 4, 4, 4, 4, 4, 4|   % Center 6 (PLACEHOLDER)
];

array[FAC] of var bool: open;
array[FAC, STO] of var int: ship;  % units shipped from facility f to store s

constraint forall(f in FAC, s in STO) (ship[f,s] >= 0);

% Demand satisfaction
constraint forall(s in STO) (
  sum(f in FAC)(ship[f,s]) = demand[s]
);

% Capacity only if open
constraint forall(f in FAC) (
  sum(s in STO)(ship[f,s]) <= capacity[f] * bool2int(open[f])
);

var int: totalOpenCost = sum(f in FAC)(openCost[f] * bool2int(open[f]));
var int: totalTransCost = sum(f in FAC, s in STO)(transCost[f,s] * ship[f,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "TOTAL COST = ", show(totalCost), "\n",
  "Open cost  = ", show(totalOpenCost), "\n",
  "Trans cost = ", show(totalTransCost), "\n\n",
  "Open centers:\n",
  concat([ if fix(open[f]) then "  Center " ++ show(f) ++ "\n" else "" endif | f in FAC ]),
  "\nShipments (center x store):\n",
  concat([
    "Center " ++ show(f) ++ ": " ++
    concat([ show(ship[f,s]) ++ (if s < S then " " else "" endif) | s in STO ]) ++ "\n"
    | f in FAC
  ])
];