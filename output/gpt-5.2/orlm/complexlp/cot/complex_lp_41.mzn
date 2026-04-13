% Parameters (with values embedded)
int: N = 6;
set of int: R = 1..N;

array[R] of int: available = [42, 32, 398, 224, 210, 209];
array[R] of int: required  = [74, 476, 2, 235, 221, 72];

% cost[i,j] = cost to ship 1 ton from region i to region j (i != j), 0 on diagonal
array[R,R] of int: cost =
[
 | 0, 16, 48, 42, 50,  8
  |27,  0, 23, 37, 39, 29
  |49, 39,  0, 33, 50,  6
  |23, 49, 46,  0, 50,  6
  |45, 47, 48, 26,  0, 39
  |33, 11,  9,  4, 12,  0
];

% Total available supply is insufficient; allow external purchase (source) at high penalty
int: BIG = 1000000;

% Variables
array[R,R] of var 0..sum(available): x;   % x[i,j] = tons shipped from i to j
array[R] of var 0..sum(required): buy;    % buy[j] = tons purchased externally for region j

% Constraints
constraint forall(i in R) ( x[i,i] = 0 );

% Flow balance: outgoing from i cannot exceed its available supply
constraint forall(i in R) (
  sum(j in R) x[i,j] <= available[i]
);

% Each region must end with at least its required amount:
% available + incoming + buy - outgoing >= required
constraint forall(j in R) (
  available[j] + sum(i in R) x[i,j] + buy[j] - sum(k in R) x[j,k] >= required[j]
);

% Objective
var int: total_cost = sum(i in R, j in R) (cost[i,j] * x[i,j]) + BIG * sum(j in R) buy[j];

solve minimize total_cost;