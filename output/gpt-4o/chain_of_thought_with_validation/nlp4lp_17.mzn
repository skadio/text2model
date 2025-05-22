int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;
array[1..L] of float: Cost;

float: M = 1.0e9;

array[1..L] of var 0.0..M: x;

var float: profit =
    sum(p in 1..P)(
        Price[p] * sum(l in 1..L)(Output[l,p] * x[l])
    ) -
    sum(l in 1..L)(Cost[l] * x[l]);

constraint
    forall(o in 1..O)(
        sum(l in 1..L)(Input[l,o] * x[l]) <= Allocated[o]
    );

solve maximize profit;