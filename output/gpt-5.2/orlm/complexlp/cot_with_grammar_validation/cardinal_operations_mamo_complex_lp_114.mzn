% Parameters
int: N = 6;
set of int: CITIES = 0..N-1;
int: SRC = 0;
int: SNK = 5;

array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
  [ 0,  9, 13,  0, 20, 16,
    6,  0, 19, 11, 14, 15,
   11,  6,  0,  8,  3, 10,
   16,  2, 17,  0,  1, 17,
    4, 12,  5, 16,  0, 15,
    7, 19, 18,  6,  8,  0 ]);

int: U = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..U: f;
var 0..(N*U): total_flow;

% Constraints
constraint
  forall(i in CITIES, j in CITIES) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in CITIES) (
    f[i,i] = 0
  );

constraint
  forall(v in CITIES where v != SRC /\ v != SNK) (
    sum(i in CITIES)(f[i,v]) = sum(j in CITIES)(f[v,j])
  );

constraint
  total_flow = sum(j in CITIES)(f[SRC,j]) - sum(i in CITIES)(f[i,SRC]);

constraint
  total_flow = sum(i in CITIES)(f[i,SNK]) - sum(j in CITIES)(f[SNK,j]);

% Objective
solve maximize total_flow;