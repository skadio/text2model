include "globals.mzn";

int: N = 5;
set of int: W = 1..N;

array[W, W] of int: cost = [|
  0, 15, 88, 54, 92,
  15, 0, 29, 98, 33,
  88, 29, 0, 96, 96,
  54, 98, 96, 0, 63,
  92, 33, 96, 63, 0
|];

array[W] of var W: succ;
array[W] of var 1..N: pos;
var int: total_cost;

constraint forall(i in W)(succ[i] != i);
constraint circuit(succ);

constraint alldifferent(pos);
constraint forall(i in W, j in W where i != j)(
  (succ[i] = j) -> (pos[j] = ((pos[i] mod N) + 1))
);

constraint total_cost = sum(i in W)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n",
  "pos=", show(pos), "\n"
];