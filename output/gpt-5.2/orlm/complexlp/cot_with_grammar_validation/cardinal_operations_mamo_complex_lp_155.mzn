int: N = 9;
int: M = 5;

set of int: DC = 1..N;
set of int: STO = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[DC, STO] of int: transCost =
  [| 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5
   | 1, 4, 2, 5, 4
   | 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4
   | 1, 3, 5, 3, 5
   | 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5
   | 2, 4, 4, 4, 4 |];

array[STO] of int: demand = [908, 434, 605, 480, 961];
array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

int: maxDemand = max(demand);

array[DC] of var bool: open;
array[DC, STO] of var 0..maxDemand: ship;

var int: totalCost;

constraint
  forall(j in STO) (
    sum(i in DC)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in DC) (
    sum(j in STO)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

constraint
  totalCost =
    sum(i in DC)(openCost[i] * bool2int(open[i])) +
    sum(i in DC, j in STO)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];