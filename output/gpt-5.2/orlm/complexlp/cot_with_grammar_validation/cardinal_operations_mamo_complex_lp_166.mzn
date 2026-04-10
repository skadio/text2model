int: N = 9;
int: M = 6;

array[1..N] of int: openCost = [151000,192000,114000,171000,160000,120000,182000,186000,174000];

array[1..N, 1..M] of int: transpCost =
[| 3,5,4,3,5,2
 | 4,2,4,5,1,4
 | 2,5,4,1,1,3
 | 3,2,4,4,3,4
 | 4,1,3,5,3,5
 | 1,2,4,1,4,2
 | 2,1,2,5,2,4
 | 4,4,4,5,3,1
 | 4,2,4,2,2,4
 |];

array[1..M] of int: demand = [876,801,955,561,601,669];
array[1..N] of int: capacity = [1615,1255,1816,1095,1519,1137,1678,1876,1591];

int: totalDemand = sum(j in 1..M)(demand[j]);

array[1..N] of var bool: open;
array[1..N, 1..M] of var 0..totalDemand: ship;

var int: totalCost;

constraint
  forall(j in 1..M)(
    sum(i in 1..N)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in 1..N)(
    sum(j in 1..M)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

constraint
  totalCost =
    sum(i in 1..N)(openCost[i] * bool2int(open[i])) +
    sum(i in 1..N, j in 1..M)(transpCost[i,j] * ship[i,j]);

solve minimize totalCost;

output ["totalCost = \(totalCost)\n"];