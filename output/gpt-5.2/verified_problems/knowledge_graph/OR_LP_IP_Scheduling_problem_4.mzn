int: n;
array[1..n, 1..n] of int: huts; % 1 if hut present (or count of huts), 0 otherwise

set of int: ROWS = 1..n;
set of int: COLS = 1..n;

% Decision variables: coordinates of the 2 airdrop locations
array[1..2] of var ROWS: drop_r;
array[1..2] of var COLS: drop_c;

% Ensure the two locations are different
constraint (drop_r[1] != drop_r[2]) \/ (drop_c[1] != drop_c[2]);

% Symmetry breaking (optional): order the two drops
constraint drop_r[1] < drop_r[2] \/ (drop_r[1] == drop_r[2] /\ drop_c[1] < drop_c[2]);

% Squared Euclidean distance from cell (i,j) to drop k
function var int: sqdist(int: i, int: j, int: k) =
  (i - drop_r[k])*(i - drop_r[k]) + (j - drop_c[k])*(j - drop_c[k]);

% Objective: sum over all huts of (count at cell) * min squared distance to a drop
var int: total_cost =
  sum(i in ROWS, j in COLS) (
    huts[i,j] * min([sqdist(i,j,1), sqdist(i,j,2)])
  );

solve minimize total_cost;

output [
  "drop1=(", show(drop_r[1]), ",", show(drop_c[1]), ")\n",
  "drop2=(", show(drop_r[2]), ",", show(drop_c[2]), ")\n",
  "total_cost=", show(total_cost), "\n"
];