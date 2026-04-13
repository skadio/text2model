int: N = 9;
int: M = 5;

array[1..N] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];
array[1..N] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];
array[1..M] of int: demand = [908, 434, 605, 480, 961];

array[1..N, 1..M] of int: transCost =
  array2d(1..N, 1..M, [
    3, 5, 4, 3, 5,
    2, 4, 2, 4, 5,
    1, 4, 2, 5, 4,
    1, 1, 3, 3, 2,
    4, 4, 3, 4, 4,
    1, 3, 5, 3, 5,
    1, 2, 4, 1, 4,
    2, 2, 1, 2, 5,
    2, 4, 4, 4, 4
  ]);

int: totalDemand = sum(j in 1..M)(demand[j]);

array[1..N] of var bool: open;
array[1..N, 1..M] of var 0..totalDemand: ship;

constraint forall(j in 1..M) (
  sum(i in 1..N)(ship[i,j]) = demand[j]
);

constraint forall(i in 1..N) (
  sum(j in 1..M)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

solve minimize
  sum(i in 1..N)(openCost[i] * bool2int(open[i])) +
  sum(i in 1..N, j in 1..M)(transCost[i,j] * ship[i,j]);

output [
  "totalCost=",
  show(
    sum(i in 1..N)(openCost[i] * bool2int(open[i])) +
    sum(i in 1..N, j in 1..M)(transCost[i,j] * ship[i,j])
  ),
  "\n",
  "open=", show([bool2int(open[i]) | i in 1..N]), "\n",
  "ship=\n",
  concat([
    concat([
      show(ship[i,j]) ++ (if j = M then "\n" else " " endif)
      | j in 1..M
    ])
    | i in 1..N
  ])
];