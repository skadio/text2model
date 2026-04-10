int: M = 4;
int: N = 8;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000];

array[DC, ST] of int: transp_cost =
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3
  |];

array[ST] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[DC] of int: capacity = [1041, 1576, 1364, 1697];

array[DC] of var bool: open;

array[DC, ST] of var 0..1000: ship;

constraint forall(s in ST) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

constraint forall(d in DC, s in ST) (
  ship[d, s] <= demand[s] * bool2int(open[d])
);

solve minimize
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transp_cost[d, s] * ship[d, s]);

output [
  "total_cost = ", show(
    sum(d in DC)(open_cost[d] * bool2int(open[d])) +
    sum(d in DC, s in ST)(transp_cost[d, s] * ship[d, s])
  ), "\n",
  "open = ", show([bool2int(open[d]) | d in DC]), "\n"
];