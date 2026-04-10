int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;

array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;

array[1..L] of float: Cost;

array[1..L] of var float: x; % number of times each process is executed (can be fractional)

% Resource availability constraints (crude oil options)
constraint
  forall(o in 1..O) (
    sum(l in 1..L) (Input[l,o] * x[l]) <= Allocated[o]
  );

% Non-negativity of process executions
constraint forall(l in 1..L) (x[l] >= 0.0);

% Objective: maximize profit = revenue - process costs
var float: profit =
  sum(l in 1..L) (
    sum(p in 1..P) (Price[p] * Output[l,p]) * x[l]
    - Cost[l] * x[l]
  );

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "x = [", concat([ if l>1 then ", " else "" endif ++ show(x[l]) | l in 1..L ]), "]\n"
];