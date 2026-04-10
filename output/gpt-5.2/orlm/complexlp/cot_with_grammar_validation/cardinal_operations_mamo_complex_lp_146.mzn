int: M = 9;
int: N = 8;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[ST] of int: demand = [414, 920, 635, 701, 819, 503, 777, 689];

array[DC] of int: cap = [1962, 1475, 1030, 1680, 1555, 1290, 1410, 1605, 1345];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  3, 6, 7, 5, 8, 6, 7, 9,
  4, 5, 6, 7, 6, 8, 5, 7,
  6, 7, 4, 6, 5, 7, 8, 6,
  5, 8, 6, 4, 7, 5, 6, 8,
  7, 6, 5, 7, 4, 6, 7, 5,
  6, 7, 8, 5, 6, 4, 5, 7,
  8, 6, 7, 6, 7, 5, 4, 6,
  7, 8, 6, 7, 5, 7, 6, 4,
  5, 7, 6, 8, 6, 5, 7, 6
]);

int: totalDemand = sum(s in ST)(demand[s]);
int: maxTransCost = max([transCost[d, s] | d in DC, s in ST]);
int: maxOpenCost = max(openCost);

array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var 0..(M * maxOpenCost + totalDemand * maxTransCost): totalCost;

constraint
  forall(s in ST)(
    sum(d in DC)(ship[d, s]) = demand[s]
  );

constraint
  forall(d in DC)(
    sum(s in ST)(ship[d, s]) <= cap[d] * bool2int(open[d])
  );

constraint
  totalCost =
    sum(d in DC)(openCost[d] * bool2int(open[d])) +
    sum(d in DC, s in ST)(transCost[d, s] * ship[d, s]);

solve minimize totalCost;

output ["totalCost=", show(totalCost), "\n"];