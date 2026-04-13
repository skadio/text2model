% Facility Location / Transportation (Capacitated) - embedded data

int: N_DC = 6;
int: N_S  = 9;

set of int: DC = 1..N_DC;
set of int: S  = 1..N_S;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, S] of int: transCost =
[| 2, 3, 4, 5, 6, 7, 8, 3, 2
 | 4, 2, 3, 4, 5, 6, 7, 3, 4
 | 1, 1, 2, 3, 4, 5, 6, 3, 4
 | 4, 1, 2, 3, 4, 5, 6, 3, 4
 | 1, 4, 2, 3, 4, 5, 6, 3, 4
 | 4, 4, 4, 4, 4, 4, 4, 4, 4
 |];

array[S] of int: demand = [401, 507, 664, 693, 670, 775, 955, 707, 444];
array[DC] of int: capacity = [1795, 1312, 1405, 1258, 1120, 1095];

int: totalDemand = sum(s in S)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, S] of var 0..totalDemand: ship;

% Constraints: meet demand exactly
constraint
  forall(s in S)(
    sum(i in DC)(ship[i,s]) = demand[s]
  );

% Capacity only if opened
constraint
  forall(i in DC)(
    sum(s in S)(ship[i,s]) <= capacity[i] * bool2int(open[i])
  );

% Objective: minimize opening + transport costs
var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, s in S)(transCost[i,s] * ship[i,s]);

solve :: int_search([ship[i,s] | i in DC, s in S] ++ [bool2int(open[i]) | i in DC],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[i]) | i in DC]), "\n",
  "ship=\n"
] ++
[ concat([ show(ship[i,s]) ++ if s==N_S then "\n" else " " endif | s in S ]) | i in DC ];