% Food transfer / transportation problem (min-cost flow)
% Data embedded as requested.

int: n = 6;
set of int: R = 1..n;

array[R] of int: have = [42, 32, 398, 224, 210, 209];
array[R] of int: need = [74, 476, 2, 235, 221, 72];

array[R,R] of int: cost = 
[|  0, 16, 48, 42, 50,  8
 | 27,  0, 23, 37, 39, 29
 | 49, 39,  0, 33, 50,  6
 | 23, 49, 46,  0, 50,  6
 | 45, 47, 48, 26,  0, 39
 | 33, 11,  9,  4, 12,  0 |];

% Net requirement (positive means deficit; negative means surplus)
array[R] of int: b = [ need[i] - have[i] | i in R ];

% Big-M upper bound on any single arc shipment:
% no shipment needs to exceed total demand (or total supply).
int: total_deficit = sum(i in R where b[i] > 0)(b[i]);
int: total_surplus = sum(i in R where b[i] < 0)(-b[i]);
int: M = max(total_deficit, total_surplus);

% x[i,j] = amount shipped from i to j (tons)
array[R,R] of var 0..M: x;

% Flow balance:
% in - out == deficit (b[i])
constraint
  forall(i in R)(
    sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = b[i]
  );

% Optional: no self-shipment (can be left free since cost is 0 and it cancels)
constraint forall(i in R)(x[i,i] = 0);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments (from i to j):\n",
  concat([ if fix(x[i,j]) > 0 then
            "  " ++ show(i) ++ " -> " ++ show(j) ++ " : " ++ show(x[i,j]) ++ "\n"
          else "" endif
          | i in R, j in R ])
];