% Parameters
int: O;
int: P;
int: L;
array1d(1..O, int) : Allocated;
array1d(1..P, int) : Price;
array2d(1..L, 1..O, int) : Input;
array2d(1..L, 1..P, int) : Output;
array1d(1..L, int) : Cost;

% Variables
var float: x[L] = 0..inf;

% Constraints
constraint forall(o in 1..O) (
    sum(l in 1..L) Input[l,o] * x[l] <= Allocated[o]
);

% Objective
solve maximize sum(l in 1..L) (sum(p in 1..P) Output[l,p] * (Price[p] - Cost[l])) * x[l];