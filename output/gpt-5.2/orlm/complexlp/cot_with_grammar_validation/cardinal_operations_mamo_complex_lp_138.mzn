% Parameters
int: N = 6;
set of int: CITIES = 0..N-1;
int: SOURCE = 0;
int: SINK = 5;

array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES,
[
  0, 14, 15, 13,  0,  4,
 10,  0,  7, 18,  9,  5,
 11,  0,  0,  7, 13,  6,
  7, 11, 18,  0, 17,  2,
 19,  8, 15, 15,  0,  5,
 10, 19, 17,  2,  3,  0
]);

int: totalCap = sum(i,j in CITIES where cap[i,j] > 0)(cap[i,j]);

% Variables
array[CITIES, CITIES] of var 0..totalCap: flow;
var 0..totalCap: maxflow;

% Constraints
constraint
  forall(i,j in CITIES)(
    flow[i,j] <= cap[i,j]
  );

constraint
  forall(i,j in CITIES where cap[i,j] = 0)(
    flow[i,j] = 0
  );

constraint
  forall(k in CITIES where k != SOURCE /\ k != SINK)(
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

constraint
  maxflow = sum(j in CITIES)(flow[SOURCE,j]) - sum(i in CITIES)(flow[i,SOURCE]);

constraint
  maxflow = sum(i in CITIES)(flow[i,SINK]) - sum(j in CITIES)(flow[SINK,j]);

% Objective
solve maximize maxflow;