% Parameters
int: N = 6;
set of int: CITIES = 0..N-1;

int: s = 0;
int: t = 5;

array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
  [ 0,  6,  8,  1,  9,  8,
   16,  0,  6,  0, 12, 16,
    7, 16,  0, 20, 17,  9,
    3, 11, 14,  0,  7,  0,
    6, 19, 19,  3,  0, 20,
   20,  5, 16, 12,  2,  0 ]);

int: U = sum(i in CITIES, j in CITIES)(cap[i,j]);

% Variables
array[CITIES, CITIES] of var 0..U: f;

var 0..U: maxflow;

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
  forall(v in CITIES where v != s /\ v != t) (
    sum(i in CITIES)(f[i,v]) = sum(j in CITIES)(f[v,j])
  );

constraint
  maxflow = sum(j in CITIES)(f[s,j]) - sum(i in CITIES)(f[i,s]);

% Objective
solve maximize maxflow;