% Parameters (with values embedded)
int: N = 4;
set of int: H = 1..N;

array[H] of int: supply = [480, 492, 74, 317];
array[H] of int: demand  = [ 61, 313, 93, 199];

array[H,H] of int: cost =
[|  0,  8, 42, 27
 | 17,  0, 13, 30
 |  4, 14,  0, 16
 | 33,  9, 42,  0 |];

% Variables
% x[i,j] = units transferred from hospital i to hospital j
array[H,H] of var 0..max(supply): x;

% Constraints
% No self-transfer
constraint forall(i in H) (x[i,i] = 0);

% Flow balance: final inventory at each hospital must meet exactly its demand
constraint
  forall(j in H) (
    supply[j] + sum(i in H)(x[i,j]) - sum(k in H)(x[j,k]) = demand[j]
  );

% Objective
var int: total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Transfer matrix x (from i to j):\n",
  concat([ concat([ show(x[i,j]) ++ if j==N then "\n" else "\t" endif
                  | j in H ])
          | i in H ])
];