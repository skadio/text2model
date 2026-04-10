% Traveling Salesperson Problem with 4 cities (embedded data)

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  % to:   1   2   3   4
  /*1*/ [  0, 27, 48, 76],
  /*2*/ [ 27,  0, 82, 88],
  /*3*/ [ 48, 82,  0, 97],
  /*4*/ [ 76, 88, 97,  0]
];

array[CITIES] of var CITIES: next;
array[CITIES] of var CITIES: prev;

constraint
  forall(i in CITIES)(next[i] != i /\ prev[i] != i);

constraint
  forall(j in CITIES)(
    sum(i in CITIES)(bool2int(next[i] = j)) = 1 /\
    sum(i in CITIES)(bool2int(prev[i] = j)) = 1
  );

constraint
  forall(i in CITIES, j in CITIES)( (next[i] = j) <-> (prev[j] = i) );

include "globals.mzn";
constraint circuit(next);

var int: total_cost = sum(i in CITIES)(cost[i, next[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Next city mapping (i -> next[i]):\n",
  concat([ show(i) ++ " -> " ++ show(next[i]) ++ "\n" | i in CITIES ])
];