int: N = 8;
int: M = 5;

array[1..N] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[1..N, 1..M] of int: trans_cost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[1..M] of int: demand = [964, 739, 491, 766, 854];
array[1..N] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: total_demand = sum(j in 1..M)(demand[j]);

array[1..N] of var bool: open;
array[1..N, 1..M] of var 0..total_demand: ship;

constraint forall(j in 1..M)(
  sum(i in 1..N)(ship[i, j]) = demand[j]
);

constraint forall(i in 1..N)(
  sum(j in 1..M)(ship[i, j]) <= capacity[i] * bool2int(open[i])
);

solve minimize
  sum(i in 1..N)(open_cost[i] * bool2int(open[i])) +
  sum(i in 1..N, j in 1..M)(trans_cost[i, j] * ship[i, j]);

output [
  "total_cost=", show(
    sum(i in 1..N)(open_cost[i] * bool2int(open[i])) +
    sum(i in 1..N, j in 1..M)(trans_cost[i, j] * ship[i, j])
  ), "\n"
];