int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L] of float: Cost;
array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;

var float: times[1..L];

constraint
  forall(l in 1..L)(times[l] >= 0);

constraint
  forall(o in 1..O)(
    sum(l in 1..L)(Input[l,o] * times[l]) <= Allocated[o]
  );

var float: profit = sum(l in 1..L)(
  (sum(p in 1..P)(Output[l,p] * Price[p]) - Cost[l]) * times[l]
);

solve :: maximize profit;

output [
  "Times: ", show(times), "\n",
  "Profit: ", show(profit), "\n"
];