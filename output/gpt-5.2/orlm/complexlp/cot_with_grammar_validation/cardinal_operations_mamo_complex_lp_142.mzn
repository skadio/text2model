int: M = 9;
int: N = 6;

set of int: Centers = 1..M;
set of int: Stores = 1..N;

array[Centers] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Centers, Stores] of int: trans_cost =
  [| 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1, 3
   | 3, 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3, 5
   | 1, 2, 4, 1, 4, 2
   | 2, 1, 2, 5, 2, 4
   | 4, 4, 4, 5, 3, 1
   | 4, 2, 4, 2, 2, 4 |];

array[Stores] of int: demand = [876, 801, 955, 561, 601, 669];
array[Centers] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: total_demand = sum(s in Stores)(demand[s]);
int: max_trans_cost = max([trans_cost[c,s] | c in Centers, s in Stores]);
int: max_total_cost = sum(c in Centers)(open_cost[c]) + total_demand * max_trans_cost;

array[Centers] of var bool: open;
array[Centers, Stores] of var 0..total_demand: ship;

var 0..max_total_cost: total_cost;

constraint forall(s in Stores) (
  sum(c in Centers)(ship[c,s]) = demand[s]
);

constraint forall(c in Centers) (
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

constraint total_cost =
  sum(c in Centers)(open_cost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(trans_cost[c,s] * ship[c,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in Centers]), "\n"
];