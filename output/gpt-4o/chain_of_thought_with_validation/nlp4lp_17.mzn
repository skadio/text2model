% Parameters
int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L, 1..O] of float: Input;
array[1..L, 1..P] of float: Output;
array[1..L] of float: Cost;

% A large positive constant
float: BIG = 1.0e12;

% Upper bound on the execution level of each process
array[1..L] of float: MaxExec =
[
  if forall(o in 1..O)(Input[l,o] = 0.0) then BIG
  else
    min([ if Input[l,o] > 0.0 then Allocated[o] / Input[l,o] else BIG endif | o in 1..O ])
  endif
  | l in 1..L
];

% Variables
array[1..L] of var 0.0..BIG: x;   % number of times each process is executed

% Constraints
constraint forall(l in 1..L)( x[l] <= MaxExec[l] );

constraint
  forall(o in 1..O)(
    sum(l in 1..L)(Input[l,o] * x[l]) <= Allocated[o]
  );

% Objective (cost is per barrel produced)
var float: profit =
    sum(l in 1..L)(
      x[l] * (
        sum(p in 1..P)( Output[l,p] * (Price[p] - Cost[l]) )
      )
    );

solve maximize profit;