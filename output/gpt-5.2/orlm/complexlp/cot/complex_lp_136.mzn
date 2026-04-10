% Parameters (with values embedded)
int: N = 7;
set of int: H = 0..N-1;
int: s = 0;
int: t = 6;

array[H, H] of int: cap =
[| 0, 15,  2, 16,  3,  5,  3
 | 7,  0,  0,  0, 19, 15, 16
 |11, 14,  0, 14,  8, 11,  6
 |17, 11, 11,  0, 11, 16, 19
 |10,  4, 17, 20,  0, 12, 17
 | 3,  0,  4,  5, 20,  0,  4
 |15,  2, 15, 18, 17,  7,  0
 |];

% Variables
int: maxCap = max([cap[i,j] | i in H, j in H]);
int: UBflow = (N-1) * maxCap;

array[H, H] of var 0..UBflow: f;
var 0..UBflow: total_flow;

% Constraints
constraint
  forall(i in H, j in H) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in H where i != s /\ i != t) (
    sum(j in H)(f[i,j]) = sum(j in H)(f[j,i])
  );

constraint
  total_flow = sum(j in H)(f[s,j]) - sum(j in H)(f[j,s]);

constraint
  total_flow = sum(j in H)(f[j,t]) - sum(j in H)(f[t,j]);

% Objective
solve maximize total_flow;