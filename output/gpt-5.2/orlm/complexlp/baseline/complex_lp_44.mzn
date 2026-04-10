int: N = 7;
set of int: R = 1..N;

array[R] of int: supply = [318, 349, 129, 381, 430, 52, 124];
array[R] of int: demand = [309, 9, 279, 71, 365, 233, 483];

array[R,R] of int: cost = array2d(R, R, [
  0,  2, 26, 19, 16, 26, 36,
 27,  0, 26,  4, 15, 43, 25,
 17, 45,  0, 18, 36, 37, 39,
 19, 16, 14,  0,  5, 35,  9,
 44, 47,  4,  3,  0,  2,  4,
 30, 12, 28, 10, 16,  0, 25,
 19, 16, 10,  2, 50,  4,  0
]);

% Shipments x[i,j] = units shipped from region i to region j
array[R,R] of var 0..sum(supply): x;

% Do not ship from a region to itself
constraint forall(i in R) (x[i,i] = 0);

% Outgoing shipments cannot exceed available supply
constraint forall(i in R) (
  sum(j in R)(x[i,j]) <= supply[i]
);

% Incoming shipments must cover any deficit; extra is allowed
constraint forall(j in R) (
  sum(i in R)(x[i,j]) >= max(0, demand[j] - supply[j])
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments matrix x[i,j]:\n"
] ++
[
  if j = 1 then "" else " " endif ++ show(x[i,j]) ++
  if j = N then "\n" else "" endif
  | i in R, j in R
];