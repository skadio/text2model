include "globals.mzn";

% Input
int: n;                                  % grid is 1..n x 1..n
array[1..n, 1..n] of int: huts;          % huts[r,c] = number of villagers at cell (r,c)

% Decision variables: exactly 2 airdrop locations (row/col for each)
array[1..2] of var 1..n: drop_r;
array[1..2] of var 1..n: drop_c;

% Symmetry breaking: order the two drops to avoid equivalent swapped solutions
constraint drop_r[1] < drop_r[2] \/
          (drop_r[1] = drop_r[2] /\ drop_c[1] < drop_c[2]);

% Objective: sum over all grid cells of huts * min squared distance to a drop
var int: total_cost =
  sum(r in 1..n, c in 1..n) (
    huts[r,c] *
    min( (r - drop_r[1])*(r - drop_r[1]) + (c - drop_c[1])*(c - drop_c[1]),
         (r - drop_r[2])*(r - drop_r[2]) + (c - drop_c[2])*(c - drop_c[2]) )
  );

solve minimize total_cost;

output [
  "Drop 1 = (", show(drop_r[1]), ",", show(drop_c[1]), ")\n",
  "Drop 2 = (", show(drop_r[2]), ",", show(drop_c[2]), ")\n",
  "TotalSquaredDistanceCost = ", show(total_cost), "\n"
];