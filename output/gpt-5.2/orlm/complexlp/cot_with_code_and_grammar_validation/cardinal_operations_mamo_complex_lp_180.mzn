% Parameters
int: n = 10;
array[1..n] of int: a = [0,10,20,30,40,50,60,70,80,90];
array[1..n] of int: b = [60,70,80,90,100,110,120,130,140,150];

int: maxB = max(b);
int: maxSep = maxB; % safe upper bound for minimum separation

% Variables
array[1..n] of var 0..maxB: t;   % landing times
var 0..maxSep: s;                % minimum separation to maximize

% Constraints
constraint forall(j in 1..n) (
  t[j] >= a[j] /\ t[j] <= b[j]
);

constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= s
);

% (Optional) implied ordering (already implied by separation when s>=0)
constraint forall(j in 1..n-1) (
  t[j] <= t[j+1]
);

% Objective
solve maximize s;