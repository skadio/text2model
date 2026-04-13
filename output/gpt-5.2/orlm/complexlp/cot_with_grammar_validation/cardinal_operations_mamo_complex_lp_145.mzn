int: M = 8;
int: N = 8;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: transCost =
[|
  3, 5, 4, 7, 6, 5, 3, 4 |
  2, 6, 5, 8, 7, 6, 4, 4 |
  4, 3, 6, 5, 8, 7, 5, 6 |
  5, 4, 3, 6, 5, 8, 6, 7 |
  6, 5, 4, 3, 6, 5, 7, 8 |
  7, 6, 5, 4, 3, 6, 8, 7 |
  5, 7, 6, 5, 4, 3, 6, 5 |
  4, 4, 7, 6, 5, 4, 3, 4
|];

array[ST] of int: demand = [695, 710, 635, 525, 590, 610, 480, 440];
array[DC] of int: capacity = [1980, 2020, 1750, 1900, 1800, 1850, 2000, 1962];

int: totalDemand = sum(i in ST)(demand[i]);
int: maxTransCost = max([transCost[d,i] | d in DC, i in ST]);
int: maxOpenCost = max([openCost[d] | d in DC]);
int: objUB = totalDemand * maxTransCost + M * maxOpenCost;

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var 0..objUB: totalCost;

constraint forall(i in ST) (
  sum(d in DC)(ship[d,i]) = demand[i]
);

constraint forall(d in DC) (
  sum(i in ST)(ship[d,i]) <= capacity[d]
);

constraint forall(d in DC, i in ST) (
  ship[d,i] <= demand[i] * bool2int(open[d])
);

constraint totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, i in ST)(transCost[d,i] * ship[d,i]);

solve minimize totalCost;