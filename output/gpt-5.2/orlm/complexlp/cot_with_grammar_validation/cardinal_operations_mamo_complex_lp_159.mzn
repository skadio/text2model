int: I = 9;
int: J = 9;

set of int: Centers = 1..I;
set of int: Stores  = 1..J;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Stores] of int: demand = [
  871, 462, 538, 898, 992, 791, 818, 688, 778
];

array[Centers] of int: capacity = [
  840, 900, 950, 1000, 1100, 1200, 1300, 1500, 1856
];

array[Centers, Stores] of int: transCost = array2d(Centers, Stores, [
  1,2,3,4,5,1,2,3,4,
  2,3,4,5,1,2,3,4,5,
  3,4,5,1,2,3,4,5,1,
  4,5,1,2,3,4,5,1,2,
  5,1,2,3,4,5,1,2,3,
  1,3,5,2,4,1,3,5,2,
  2,4,1,3,5,2,4,1,3,
  3,5,2,4,1,3,5,2,4,
  4,1,3,5,2,4,1,3,5
]);

int: totalDemand = sum(j in Stores)(demand[j]);
int: maxCap = max(i in Centers)(capacity[i]);
int: maxTransCost = max(i in Centers, j in Stores)(transCost[i,j]);
int: maxTotalCost = sum(i in Centers)(openCost[i]) + totalDemand * maxTransCost;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxCap: ship;

var 0..maxTotalCost: totalCost;

constraint
  forall(j in Stores) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(ship[i,j]) <= capacity[i]
  );

constraint
  forall(i in Centers, j in Stores) (
    ship[i,j] <= capacity[i] * bool2int(open[i])
  );

constraint
  totalCost =
    sum(i in Centers)(openCost[i] * bool2int(open[i])) +
    sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;