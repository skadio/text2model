% Emergency food redistribution - minimum transportation cost
% Data embedded directly in the model.

int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [268, 222, 357, 128, 465, 48];
array[R] of int: demand = [165, 246, 262, 286, 439, 83];

array[R,R] of int: cost =
[
  % to:   1   2   3   4   5   6
  /*1*/ [ 0, 49, 11, 23,  2, 39],
  /*2*/ [33,  0, 26,  2,  2, 14],
  /*3*/ [12, 31,  0, 36, 30, 34],
  /*4*/ [18, 50, 12,  0, 19, 20],
  /*5*/ [ 3, 13, 20, 29,  0,  1],
  /*6*/ [ 2,  9, 50, 36, 39,  0]
];

% Net balance: positive means surplus, negative means deficit.
array[R] of int: net = [supply[i] - demand[i] | i in R];

% Flow x[i,j] = units shipped from region i to region j (i != j).
array[R,R] of var 0..sum(supply): x;

constraint forall(i in R) (x[i,i] = 0);

% Flow conservation:
% outgoing - incoming = net (surplus ships out, deficit receives).
constraint forall(i in R) (
  sum(j in R)(x[i,j]) - sum(j in R)(x[j,i]) = net[i]
);

var int: total_cost = sum(i,j in R where i != j)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipment matrix (rows=from, cols=to):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(x[i,j]) | j in R]) ++ "\n" | i in R ])
];