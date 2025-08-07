int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

var 0..sup: x[1..OriginNum, 1..DestinationNum];

constraint
  forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum) x[i,j] <= Supply[i]
  );

constraint
  forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum) x[i,j] == Demand[j]
  );

var int: totalCost = sum(i in 1..OriginNum, j in 1..DestinationNum) x[i,j] * Cost[i,j];

solve minimize totalCost;

output [
  "Total Cost: \(totalCost)\n",
  "Allocation:\n",
  show(x)
];