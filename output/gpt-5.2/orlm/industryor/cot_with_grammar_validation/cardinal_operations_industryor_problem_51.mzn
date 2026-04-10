% Parameters
int: N = 6;
set of int: S = 1..N;

array[S] of int: req = [60, 70, 60, 50, 20, 30];

% coverage matrix: cov[s,t] = 1 if staff starting at shift s covers time period t (8h = 2 consecutive 4h periods)
array[S,S] of int: cov =
[| 1, 1, 0, 0, 0, 0  % start 1 covers periods 1,2
 | 0, 1, 1, 0, 0, 0  % start 2 covers periods 2,3
 | 0, 0, 1, 1, 0, 0  % start 3 covers periods 3,4
 | 0, 0, 0, 1, 1, 0  % start 4 covers periods 4,5
 | 0, 0, 0, 0, 1, 1  % start 5 covers periods 5,6
 | 1, 0, 0, 0, 0, 1  % start 6 covers periods 6,1 (wrap)
 |];

% Variables
array[S] of var 0..sum(req): x;   % x[s] = number of staff starting at shift s
var 0..(N * sum(req)): total_staff = sum(s in S)(x[s]);

% Constraints
constraint
  forall(t in S)(
    sum(s in S)(cov[s,t] * x[s]) >= req[t]
  );

% Objective
solve minimize total_staff;