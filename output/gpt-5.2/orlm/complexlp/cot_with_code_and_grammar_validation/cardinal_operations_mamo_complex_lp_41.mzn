% Parameters
int: N = 6;
set of int: R = 1..N;

array[R] of int: initial = [42, 32, 398, 224, 210, 209];
array[R] of int: required = [74, 476, 2, 235, 221, 72];

array[R, R] of int: cost =
  [|  0, 16, 48, 42, 50,  8
   | 27,  0, 23, 37, 39, 29
   | 49, 39,  0, 33, 50,  6
   | 23, 49, 46,  0, 50,  6
   | 45, 47, 48, 26,  0, 39
   | 33, 11,  9,  4, 12,  0
  |];

array[R] of int: surplus = [max(0, initial[i] - required[i]) | i in R];
array[R] of int: deficit = [max(0, required[i] - initial[i]) | i in R];

int: total_surplus = sum(i in R)(surplus[i]);
int: total_deficit = sum(i in R)(deficit[i]);

% Variables
array[R, R] of var 0..total_surplus: x; % shipped amount from i to j

% Constraints
constraint forall(i in R)(x[i,i] = 0);

% Outgoing from each region limited by its surplus
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= surplus[i]
);

% Incoming to each region must cover its deficit
constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= deficit[j]
);

% Optional: ensure global feasibility (will fail if not enough supply)
constraint total_surplus >= total_deficit;

% Objective
solve minimize sum(i in R, j in R)(cost[i,j] * x[i,j]);