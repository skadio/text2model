int: nWarehouses = 7;
set of int: W = 1..nWarehouses;

array[W] of int: supply = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: demand = [499, 173, 293, 158, 15, 78, 278];

% Transportation cost per unit moved from warehouse i to warehouse j
array[W, W] of int: cost = array2d(W, W,
[
  0, 36, 36, 48, 10, 20, 48,
  28, 0, 16, 18, 36, 42, 12,
  6, 40, 0, 49, 31, 1, 46,
  14, 22, 4, 0, 9, 12, 1,
  50, 44, 7, 48, 0, 7, 25,
  26, 9, 33, 38, 8, 0, 30,
  8, 9, 2, 13, 8, 49, 0
]);

int: totalSupply = sum(w in W)(supply[w]);
int: totalDemand = sum(w in W)(demand[w]);
int: maxFlow = max(totalSupply, totalDemand);

array[W, W] of var 0..maxFlow: ship;

int: maxUnitCost = max(i in W, j in W)(cost[i, j]);
var 0..(maxFlow * maxUnitCost): totalCost;

% Disallow self-shipment
constraint forall(w in W)(ship[w,w] = 0);

% Flow balance: supply + inflow = demand + outflow
constraint
  forall(w in W)(
    supply[w] + sum(i in W)(ship[i,w]) = demand[w] + sum(j in W)(ship[w,j])
  );

% Total cost
constraint totalCost = sum(i in W, j in W)(cost[i,j] * ship[i,j]);

solve minimize totalCost;