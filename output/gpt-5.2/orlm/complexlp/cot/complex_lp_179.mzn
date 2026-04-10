% Parameters (with values embedded)
int: DAYS = 7;
set of int: D = 1..DAYS;

array[D] of float: demand = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];

% Each nurse works 5 consecutive days in a 7-day week (cyclic).
int: L = 5;
set of int: START = 1..DAYS;

% Variables
% x[s] = number of nurses whose 5-day block starts on day s (continuous, nonnegative)
array[START] of var float: x;
var float: total_nurses;

% Constraints
constraint forall(s in START)(x[s] >= 0.0);

% Coverage: day j is covered by nurses starting in {j, j-1, ..., j-4} modulo 7
constraint forall(j in D)(
  sum(k in 0..L-1)(
    x[ if j-k >= 1 then j-k else j-k + DAYS endif ]
  ) >= demand[j]
);

constraint total_nurses = sum(s in START)(x[s]);

% Objective
solve minimize total_nurses;