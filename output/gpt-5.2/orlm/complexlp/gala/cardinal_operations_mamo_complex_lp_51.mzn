include "globals.mzn";

% --- Data (embedded) ---
int: n = 4;

array[1..n] of int: supply = [480, 492, 74, 317];
array[1..n] of int: need   = [ 61, 313, 93, 199];

% Cost matrix: cost[i,j] = cost to ship 1 unit from i to j
array[1..n, 1..n] of int: cost =
  [| 0,  8, 42, 27
   |17,  0, 13, 30
   | 4, 14,  0, 16
   |33,  9, 42,  0 |];

% --- Decision variables ---
% x[i,j] = units transferred from hospital i to hospital j
% No self-transfer needed; we force x[i,i] = 0.
array[1..n, 1..n] of var 0..max(supply): x;

% --- Constraints ---
constraint forall(i in 1..n)(x[i,i] = 0);

% Final inventory at each hospital must meet its need:
% supply[k] - outgoing + incoming >= need[k]
constraint
  forall(k in 1..n)(
    supply[k]
    - sum(j in 1..n)(x[k,j])
    + sum(i in 1..n)(x[i,k])
    >= need[k]
  );

% Cannot ship more than available supply from each hospital
constraint forall(i in 1..n)(
  sum(j in 1..n)(x[i,j]) <= supply[i]
);

% --- Objective ---
var int: total_cost = sum(i in 1..n, j in 1..n)(cost[i,j] * x[i,j]);

solve minimize total_cost;

% --- Output ---
output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Transfer matrix x[from,to] =\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in 1..n ]) ++ "\n"
         | i in 1..n ])
];