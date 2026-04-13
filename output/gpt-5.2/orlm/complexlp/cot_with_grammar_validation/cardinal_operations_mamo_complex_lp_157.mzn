int: F = 6;
int: S = 5;

set of int: Facilities = 1..F;
set of int: Stores = 1..S;

array[Facilities] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Facilities, Stores] of int: transCost =
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3 |];

array[Stores] of int: demand = [884, 420, 566, 673, 787];
array[Facilities] of int: capacity = [1400, 1115, 813, 1041, 1576, 1364];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxCap = max(f in Facilities)(capacity[f]);
int: maxTransCost = max(f in Facilities, s in Stores)(transCost[f, s]);

array[Facilities] of var bool: open;
array[Facilities, Stores] of var 0..maxCap: ship;

var 0..(sum(f in Facilities)(openCost[f]) + totalDemand * maxTransCost): totalCost;

constraint forall(s in Stores)(
  sum(f in Facilities)(ship[f, s]) = demand[s]
);

constraint forall(f in Facilities)(
  sum(s in Stores)(ship[f, s]) <= capacity[f] * bool2int(open[f])
);

constraint totalCost =
  sum(f in Facilities)(openCost[f] * bool2int(open[f])) +
  sum(f in Facilities, s in Stores)(transCost[f, s] * ship[f, s]);

solve minimize totalCost;