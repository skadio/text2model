% Medical supplies redistribution (minimum cost flow / transportation)

int: n = 4;
set of int: H = 1..n;

array[H] of int: initial = [480, 492, 74, 317];
array[H] of int: need    = [ 61, 313, 93, 199];

% cost[i,j] = cost to transfer 1 unit from hospital i to hospital j
array[H,H] of int: cost =
[| 0,  8, 42, 27
 |17,  0, 13, 30
 | 4, 14,  0, 16
 |33,  9, 42,  0
 |];

array[H,H] of var 0..sum(initial): x;  % x[i,j] units transferred i -> j

% No self-transfer
constraint forall(i in H)( x[i,i] = 0 );

% Flow balance: final stock at each hospital must equal its need
constraint forall(h in H)(
  initial[h] + sum(i in H)(x[i,h]) - sum(j in H)(x[h,j]) = need[h]
);

var int: total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Transfers (i -> j : units):\n"
] ++
[
  if fix(x[i,j]) > 0 then
    show(i) ++ " -> " ++ show(j) ++ " : " ++ show(x[i,j]) ++ "\n"
  else
    ""
  endif
  | i in H, j in H
];