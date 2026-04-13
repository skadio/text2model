int: N = 9;
set of int: CITIES = 0..N-1;
int: SRC = 0;
int: SNK = 8;

array[CITIES, CITIES] of int: cap =
[| 0,15,12, 9, 7,12, 5,20,10
 | 6, 0, 8, 0,19,14,17, 9,16
 |19,11, 0, 0,13,14,17,10,13
 |15, 4, 5, 0, 2,18, 6,17,19
 | 2, 8, 2, 4, 0, 6,14,20,18
 |14, 9,18, 7, 4, 0,11,11,13
 |12,14,12, 4,18, 6, 0, 5, 4
 |20, 1, 6,17, 4, 2,11, 0, 9
 |16, 6,14, 0,17,17, 6, 9, 0 |];

int: U = sum(i,j in CITIES)(cap[i,j]);

array[CITIES, CITIES] of var 0..U: f;

var 0..U: maxflow;

constraint
  forall(i,j in CITIES) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i,j in CITIES) (
    f[i,j] >= 0
  );

constraint
  forall(k in CITIES where k != SRC /\ k != SNK) (
    sum(i in CITIES)(f[i,k]) = sum(j in CITIES)(f[k,j])
  );

constraint
  maxflow = sum(j in CITIES)(f[SRC,j]) - sum(i in CITIES)(f[i,SRC]);

constraint
  maxflow = sum(i in CITIES)(f[i,SNK]) - sum(j in CITIES)(f[SNK,j]);

solve maximize maxflow;

output [
  "Maximum goods transported (tons) = ", show(maxflow), "\n"
];