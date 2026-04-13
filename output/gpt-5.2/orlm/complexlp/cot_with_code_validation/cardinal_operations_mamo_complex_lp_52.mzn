% Parameters
int: N = 5;
set of int: R = 1..N;

array[R] of int: stock = [410, 266, 132, 6, 485];
array[R] of int: need  = [274, 331, 232, 359, 74];

% Transportation cost from i to j
array[R, R] of int: cost = array2d(R, R,
[
  0, 24,  3, 27, 31,  % from 1
 24,  0, 11,  7, 37,  % from 2
 30,  1,  0, 38, 22,  % from 3
 36, 18, 17,  0, 35,  % from 4
 41, 35, 33, 33,  0   % from 5
]);

int: TOTAL_STOCK = sum(r in R)(stock[r]);
int: TOTAL_NEED  = sum(r in R)(need[r]);
int: MAXC = max(i in R, j in R)(cost[i,j]);

% Variables
array[R, R] of var 0..TOTAL_STOCK: x; % units shipped from i to j
var 0..(TOTAL_STOCK * MAXC): total_cost;

% Constraints
constraint TOTAL_STOCK = TOTAL_NEED;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= stock[i]
);

constraint forall(j in R)(
  stock[j] - sum(k in R)(x[j,k]) + sum(i in R)(x[i,j]) = need[j]
);

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "x=\n"
] ++
[
  concat([ if j = 1 then "" else " " endif ++ show(x[i,j]) | j in R ]) ++ "\n"
  | i in R
];