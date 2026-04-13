int: N = 5;
set of int: R = 1..N;

array[R, R] of int: cost = array2d(R, R, [
  0, 10, 12, 17, 34,
  10, 0, 18, 8, 46,
  12, 18, 0, 9, 27,
  17, 8, 9, 0, 20,
  34, 46, 27, 20, 0
]);

array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: demand = [300, 400, 800, 200, 300];

array[R] of int: net = [supply[i] - demand[i] | i in R];

int: total_surplus = sum(i in R)(max(net[i], 0));

array[R, R] of var 0..total_surplus: x;

var int: total_cost;

constraint forall(i in R)(x[i, i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i, j]) - sum(j in R)(x[j, i]) = net[i]
);

constraint total_cost = sum(i in R, j in R)(cost[i, j] * x[i, j]);

solve minimize total_cost;

output ["total_cost = \(total_cost)\n"];