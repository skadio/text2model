int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;

array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;

array[1..L] of float: Cost;

array[1..L] of var float: X;

constraint forall(i in 1..L) (X[i] >= 0.0);

constraint
  forall(o in 1..O) (
    sum(i in 1..L) (X[i] * Input[i, o]) <= Allocated[o]
  );

var float: TotalRevenue =
  sum(i in 1..L) (
    (sum(p in 1..P) (Price[p] * Output[i, p]) - Cost[i]) * X[i]
  );

solve maximize TotalRevenue;

output [
  "TotalRevenue=", show(TotalRevenue), "\n",
  "X=", show(X), "\n"
];