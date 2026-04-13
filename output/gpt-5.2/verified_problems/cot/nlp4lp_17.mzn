% Parameters
int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;
array[1..L] of float: Cost;

% Variables
array[1..L] of var float: x; % number of times process l is executed (can be fractional)

% Constraints
constraint forall(l in 1..L) ( x[l] >= 0.0 );

constraint forall(o in 1..O) (
  sum(l in 1..L) ( Input[l,o] * x[l] ) <= Allocated[o]
);

% Objective
solve maximize
  sum(l in 1..L) (
    sum(p in 1..P) ( Price[p] * Output[l,p] * x[l] )
    - Cost[l] * x[l]
  );