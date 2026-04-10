int: n = 4;
set of int: W = 1..n;

array[W] of int: stock = [500, 497, 354, 223];
array[W] of int: req   = [ 17,  65,  26, 332];

array[W,W] of int: cost =
  [|  0, 17,  3,  5
   | 39,  0, 18, 50
   |  8, 45,  0, 15
   | 11,  4, 29,  0 |];

int: total_stock = sum(i in W)(stock[i]);
int: total_req   = sum(i in W)(req[i]);

constraint total_stock >= total_req;

array[W,W] of var 0..total_stock: x;

constraint forall(i in W)(x[i,i] = 0);

% Net flow balance: outgoing - incoming = surplus (stock - req),
% but allow discarding extra total supply by adding a dummy sink is equivalent to
% letting one warehouse absorb discard via "waste" variable.
array[W] of var 0..total_stock: waste;

constraint sum(i in W)(waste[i]) = total_stock - total_req;

constraint forall(i in W)(
  sum(j in W)(x[i,j]) + waste[i] - sum(j in W)(x[j,i]) = stock[i] - req[i]
);

var int: total_cost = sum(i,j in W)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [show(total_cost)];