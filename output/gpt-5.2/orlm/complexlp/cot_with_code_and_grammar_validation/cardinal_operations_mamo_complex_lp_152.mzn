int: nCenters = 4;
int: nStores  = 4;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity = [1547, 1656, 1274, 1882];
array[Stores]  of int: demand   = [859, 713, 421, 652];

array[Centers, Stores] of int: shipCost =
[| 5, 5, 2, 3
 | 3, 3, 5, 4
 | 3, 5, 2, 4
 | 2, 4, 5, 1 |];

int: totalDemand = sum(s in Stores)(demand[s]);

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

var int: totalCost = 
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(shipCost[c,s] * ship[c,s]);

constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

solve minimize totalCost;

output
  [
    "totalCost=", show(totalCost), "\n",
    "open=", show([bool2int(open[c]) | c in Centers]), "\n",
    "ship=\n"
  ]
  ++
  [
    "  center " ++ show(c) ++ ": " ++ show([ship[c,s] | s in Stores]) ++ "\n"
    | c in Centers
  ];