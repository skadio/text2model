% Parameters
int: N = 7;
int: S = 0;
int: T = 6;

array[0..N-1, 0..N-1] of int: cap =
array2d(0..N-1, 0..N-1,
[
  % from 0
  0, 18000, 11000, 15000,  2000,  4000, 20000,
  % from 1
  4000,     0,  6000,  5000, 19000, 15000,     0,
  % from 2
  15000, 10000,     0,  7000,     0,  7000,  5000,
  % from 3
  14000,  5000,  3000,     0, 10000, 15000, 19000,
  % from 4
   2000, 11000,  1000, 10000,     0, 14000,  6000,
  % from 5
  10000, 14000,  6000,  5000,  3000,     0, 18000,
  % from 6
   8000,  1000, 11000,  8000,  6000, 20000,     0
]);

int: maxCap = max([cap[i,j] | i in 0..N-1, j in 0..N-1]);

% Variables
array[0..N-1, 0..N-1] of var 0..maxCap: flow;
var 0..sum(j in 0..N-1)(cap[S,j]): totalFlow;

% Constraints
constraint
  forall(i in 0..N-1, j in 0..N-1) (
    flow[i,j] <= cap[i,j]
  );

constraint
  forall(i in 0..N-1, j in 0..N-1 where i == j) (
    flow[i,j] = 0
  );

constraint
  forall(k in 0..N-1 where k != S /\ k != T) (
    sum(i in 0..N-1)(flow[i,k]) = sum(j in 0..N-1)(flow[k,j])
  );

constraint
  totalFlow = sum(j in 0..N-1)(flow[S,j]) - sum(i in 0..N-1)(flow[i,S]);

constraint
  totalFlow = sum(i in 0..N-1)(flow[i,T]) - sum(j in 0..N-1)(flow[T,j]);

% Objective
solve maximize totalFlow;