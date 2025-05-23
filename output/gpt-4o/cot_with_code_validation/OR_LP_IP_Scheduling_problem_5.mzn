% Parameters
int: rows;
int: cols;

set of int: PROGRAMMERS = 1..rows;
set of int: JOBS = 1..cols;

array[PROGRAMMERS, JOBS] of int: cost;

% Variables
array[PROGRAMMERS, JOBS] of var 0..1: x;

% Constraints
constraint
  forall(p in PROGRAMMERS)(
    sum(j in JOBS)( x[p, j] ) = 1
  );

constraint
  forall(j in JOBS)(
    sum(p in PROGRAMMERS)( x[p, j] ) <= 1
  );

% Objective
solve minimize
  sum(p in PROGRAMMERS, j in JOBS)( cost[p, j] * x[p, j] );