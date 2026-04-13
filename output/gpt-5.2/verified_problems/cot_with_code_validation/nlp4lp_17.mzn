% Oil refinery process planning (LP with continuous decisions)

% Parameters
int: O; % number of crude options
int: P; % number of products / price points
int: L; % number of processes

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;
array[1..L] of float: Cost;

% Decision variables: how many times each process is executed (continuous, nonnegative)
array[1..L] of var float: x;

% Resource constraints (do not exceed allocated crude)
constraint
  forall(o in 1..O)(
    sum(l in 1..L)(Input[l,o] * x[l]) <= Allocated[o]
  );

% Objective: maximize profit = revenue - process costs
solve maximize
  sum(l in 1..L)(
    x[l] * ( sum(p in 1..P)(Price[p] * Output[l,p]) - Cost[l] )
  );