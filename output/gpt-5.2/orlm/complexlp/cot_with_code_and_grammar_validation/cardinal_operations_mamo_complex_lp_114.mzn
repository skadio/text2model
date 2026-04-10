% Parameters
int: N = 6;
set of int: CITIES = 0..N-1;

int: SOURCE = 0;
int: SINK = 5;

array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES,
[
  0,  9, 13,  0, 20, 16,
  6,  0, 19, 11, 14, 15,
 11,  6,  0,  8,  3, 10,
 16,  2, 17,  0,  1, 17,
  4, 12,  5, 16,  0, 15,
  7, 19, 18,  6,  8,  0
]);

int: MAX_CAP = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..MAX_CAP: f;
var 0..(N*MAX_CAP): total_flow;

% Constraints
constraint
  forall(i in CITIES, j in CITIES) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in CITIES where k != SOURCE /\ k != SINK) (
    sum(i in CITIES)(f[i,k]) = sum(j in CITIES)(f[k,j])
  );

constraint
  total_flow = sum(j in CITIES)(f[SOURCE,j]) - sum(i in CITIES)(f[i,SOURCE]);

constraint
  total_flow = sum(i in CITIES)(f[i,SINK]) - sum(j in CITIES)(f[SINK,j]);

% Objective
solve maximize total_flow;