int: N = 7;
set of int: H = 1..N;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: need  = [ 19, 138, 110, 446, 341, 428,  47];

array[H,H] of int: cost =
array2d(H, H, [
  0, 12, 47, 39,  4, 21, 31,
 14,  0, 39, 12, 31, 29, 15,
 15,  6,  0, 26, 12,  5,  3,
 39, 47, 42,  0, 33, 48,  2,
 35, 25, 46, 12,  0, 25, 45,
 39, 28, 28, 11, 16,  0, 13,
 42, 43, 49, 41, 41, 18,  0
]);

array[H] of int: surplus = [ if stock[i] > need[i] then stock[i] - need[i] else 0 endif | i in H ];
array[H] of int: deficit = [ if need[i] > stock[i] then need[i] - stock[i] else 0 endif | i in H ];

int: total_surplus = sum(i in H)(surplus[i]);
int: total_deficit = sum(i in H)(deficit[i]);

array[H,H] of var 0..total_surplus: x;

constraint forall(i in H)(x[i,i] = 0);

constraint forall(i in H)(
  sum(j in H)(x[i,j]) <= surplus[i]
);

constraint forall(j in H)(
  sum(i in H)(x[i,j]) >= deficit[j]
);

constraint forall(i in H, j in H where i != j)(
  x[i,j] <= deficit[j]
);

constraint total_surplus >= total_deficit;

int: max_total_cost = total_surplus * max(i in H, j in H)(cost[i,j]);
var 0..max_total_cost: total_cost;

constraint total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output ["min_cost=", show(total_cost), "\n"];