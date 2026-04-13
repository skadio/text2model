include "globals.mzn";

int: N = 6;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 63, 62, 49, 58, 38
   | 63,  0, 93, 21, 66, 42
   | 62, 93,  0, 26, 99, 96
   | 49, 21, 26,  0, 73, 80
   | 58, 66, 99, 73,  0, 76
   | 38, 42, 96, 80, 76,  0
  |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;
array[CITIES] of var 0..N-1: pos;

var 0..1000000: total_cost;

constraint circuit(succ);

constraint forall(i in CITIES) (succ[i] != i);

constraint forall(i in CITIES, j in CITIES) (
  (succ[i] = j) <-> (pred[j] = i)
);

constraint alldifferent(pos);

constraint pos[1] = 0;
constraint forall(i in CITIES where i != 1) (pos[i] >= 1);
constraint forall(i in CITIES where i != 1) (pos[i] <= N-1);

constraint forall(i in CITIES where i != 1) (
  pos[i] + 1 <= pos[succ[i]] + (N-1) * bool2int(succ[i] = 1)
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];