int: N = 4;
set of int: H = 1..N;

array[H] of int: supply = [480, 492, 74, 317];
array[H] of int: demand = [61, 313, 93, 199];

array[H, H] of int: cost = array2d(H, H,
  [ 0,  8, 42, 27,
   17,  0, 13, 30,
    4, 14,  0, 16,
   33,  9, 42,  0 ]
);

int: total_supply = sum(h in H)(supply[h]);
int: total_demand = sum(h in H)(demand[h]);

int: max_ship = total_supply;

array[H, H] of var 0..max_ship: x;
var 0..(max_ship * max(cost)): total_cost;

constraint total_supply >= total_demand;

constraint forall(i in H)(x[i,i] = 0);

constraint forall(j in H)(
  supply[j] + sum(i in H)(x[i,j]) - sum(k in H)(x[j,k]) = demand[j]
);

constraint total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "x=\n", show(x), "\n"
];