% Supply relocation / minimum-cost transshipment between 7 warehouses

int: N = 7;
set of int: W = 1..N;

array[W] of int: start = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: need  = [499, 173, 293, 158, 15, 78, 278];

% Transportation cost c[i,j] for moving 1 unit from i to j
% (Diagonal costs set to 0; no need to ship from a warehouse to itself)
array[W,W] of int: c =
[
|  0, 36, 36, 48, 10, 20, 48
| 28,  0, 16, 18, 36, 42, 12
|  6, 40,  0, 49, 31,  1, 46
| 14, 22,  4,  0,  9, 12,  1
| 50, 44,  7, 48,  0,  7, 25
| 26,  9, 33, 38,  8,  0, 30
|  8,  9,  2, 13,  8, 49,  0
];

% Feasibility check: total supply must equal total demand for exact balancing
constraint sum(start) = sum(need);

% x[i,j] = units shipped from warehouse i to warehouse j
array[W,W] of var 0..sum(start): x;

% Flow balance at each warehouse:
% final = start - outgoing + incoming = need
constraint
  forall(i in W) (
    start[i] - sum(j in W where j != i)(x[i,j]) + sum(j in W where j != i)(x[j,i]) = need[i]
  );

var int: total_cost =
  sum(i in W, j in W where j != i)(c[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments (i -> j : amount)\n",
  concat([
    if fix(x[i,j]) > 0 then
      show(i) ++ " -> " ++ show(j) ++ " : " ++ show(x[i,j]) ++ "\n"
    else "" endif
    | i in W, j in W where j != i
  ])
];