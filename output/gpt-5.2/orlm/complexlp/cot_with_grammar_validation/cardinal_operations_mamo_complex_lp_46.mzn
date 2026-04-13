int: N = 7;
set of int: H = 1..N;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: req   = [ 19, 138, 110, 446, 341, 428,  47];

array[H, H] of int: cost = [|
  0, 12, 47, 39,  4, 21, 31 |
 14,  0, 39, 12, 31, 29, 15 |
 15,  6,  0, 26, 12,  5,  3 |
 39, 47, 42,  0, 33, 48,  2 |
 35, 25, 46, 12,  0, 25, 45 |
 39, 28, 28, 11, 16,  0, 13 |
 42, 43, 49, 41, 41, 18,  0
|];

int: total_stock = sum(h in H)(stock[h]);
int: total_req   = sum(h in H)(req[h]);

array[H, H] of var 0..total_stock: x;
var 0..(total_stock * max(i in H, j in H)(cost[i,j])): total_cost;

constraint total_stock >= total_req;
constraint forall(i in H)(x[i,i] = 0);

constraint forall(i in H)(
  sum(j in H)(x[i,j]) <= stock[i]
);

constraint forall(j in H)(
  stock[j] + sum(i in H)(x[i,j]) - sum(k in H)(x[j,k]) >= req[j]
);

constraint total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;