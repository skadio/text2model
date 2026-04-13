int: n = 5;
set of int: R = 1..n;

array[R] of int: stock = [410, 266, 132, 6, 485];
array[R] of int: need  = [274, 331, 232, 359, 74];

% Transportation cost c[i,j] = cost to ship 1 unit from region i to region j
% Diagonal entries are 0 (no self-shipment needed).
array[R, R] of int: c =
[
 | 0, 24,  3, 27, 31
  | 24, 0, 11,  7, 37
  | 30,  1, 0, 38, 22
  | 36, 18, 17, 0, 35
  | 41, 35, 33, 33, 0
|];

% Flow variables: x[i,j] units shipped from i to j
array[R, R] of var 0..sum(stock): x;

% No self-shipment
constraint forall(i in R) ( x[i,i] = 0 );

% Flow balance:
% final_i = stock_i - outgoing_i + incoming_i must equal need_i
constraint forall(i in R) (
  stock[i] - sum(j in R)(x[i,j]) + sum(j in R)(x[j,i]) = need[i]
);

var int: total_cost = sum(i in R, j in R)( c[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipments matrix x[i,j]:\n"
] ++
[
  if j = 1 then "From " ++ show(i) ++ ": " else "" endif ++
  show(x[i,j]) ++ if j = n then "\n" else " " endif
  | i in R, j in R
];