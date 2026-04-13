int: F = 6;
int: S = 9;

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];
array[FAC] of int: cap      = [1795, 1069, 1615, 1255, 1816, 1095];
array[STO] of int: demand   = [401, 789, 965, 505, 876, 801, 955, 561, 601];

array[FAC, STO] of int: transCost =
  array2d(FAC, STO, [
    2, 3, 1, 5, 2, 4, 3, 2, 2,
    4, 2, 3, 1, 5, 2, 4, 3, 4,
    3, 4, 2, 3, 1, 5, 2, 4, 3,
    5, 3, 4, 2, 3, 1, 5, 2, 4,
    2, 5, 3, 4, 2, 3, 1, 5, 2,
    4, 2, 5, 3, 4, 2, 3, 1, 5
  ]);

int: totalDemand = sum(i in STO)(demand[i]);
int: maxShip = totalDemand;

array[FAC] of var bool: open;
array[FAC, STO] of var 0..maxShip: ship;

var int: totalCost =
  sum(f in FAC)(openCost[f] * bool2int(open[f])) +
  sum(f in FAC, i in STO)(transCost[f, i] * ship[f, i]);

constraint forall(i in STO) (
  sum(f in FAC)(ship[f, i]) = demand[i]
);

constraint forall(f in FAC) (
  sum(i in STO)(ship[f, i]) <= cap[f] * bool2int(open[f])
);

solve :: int_search([ship[f,i] | f in FAC, i in STO] ++ [bool2int(open[f]) | f in FAC], first_fail, indomain_min, complete)
minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Open centers: ", show([bool2int(open[f]) | f in FAC]), "\n",
  "Shipments:\n"
] ++
[
  "Center ", show(f), ": ", show([ship[f,i] | i in STO]), "\n"
  | f in FAC
];