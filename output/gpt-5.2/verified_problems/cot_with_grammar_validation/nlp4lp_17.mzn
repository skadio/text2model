int: O;
int: P;
int: L;

set of int: OPTIONS = 1..O;
set of int: PRICES = 1..P;
set of int: PROCESSES = 1..L;

array[OPTIONS] of float: Allocated;
array[PRICES] of float: Price;
array[PROCESSES, OPTIONS] of float: Input;
array[PROCESSES, PRICES] of float: Output;
array[PROCESSES] of float: Cost;

array[PROCESSES] of var float: x;

var float: total_revenue;
var float: total_cost;
var float: profit;

constraint forall(l in PROCESSES) (x[l] >= 0.0);

constraint forall(o in OPTIONS) (
  sum(l in PROCESSES) (Input[l, o] * x[l]) <= Allocated[o]
);

constraint total_revenue =
  sum(p in PRICES) (
    Price[p] * sum(l in PROCESSES) (Output[l, p] * x[l])
  );

constraint total_cost =
  sum(l in PROCESSES) (Cost[l] * x[l]);

constraint profit = total_revenue - total_cost;

solve maximize profit;

output [
  "x = ", show(x), "\n",
  "total_revenue = ", show(total_revenue), "\n",
  "total_cost = ", show(total_cost), "\n",
  "profit = ", show(profit), "\n"
];