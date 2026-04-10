% Parameters
int: N = 6;
set of int: CITIES = 0..N-1;

int: source = 0;
int: sink = 5;

array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES,
[
  0,  6,  8,  1,  9,  8,
 16,  0,  6,  0, 12, 16,
  7, 16,  0, 20, 17,  9,
  3, 11, 14,  0,  7,  0,
  6, 19, 19,  3,  0, 20,
 20,  5, 16, 12,  2,  0
]);

int: U = max([cap[i,j] | i in CITIES, j in CITIES]); % upper bound per arc

% Variables
array[CITIES, CITIES] of var 0..U: flow;

var 0..(sum(j in CITIES)(cap[source,j])): total_flow;

% Constraints
constraint
  forall(i in CITIES, j in CITIES where i == j \/ cap[i,j] == 0) (
    flow[i,j] = 0
  );

constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

constraint
  total_flow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Objective
solve maximize total_flow;