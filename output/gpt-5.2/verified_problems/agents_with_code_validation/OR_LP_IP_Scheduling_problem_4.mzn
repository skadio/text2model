include "globals.mzn";

% Parameters
int: n;                                   % Grid size (rows = cols = n)
set of int: ROWS = 1..n;
set of int: COLS = 1..n;

array[ROWS, COLS] of int: huts;           % huts[r,c] = number of huts/villagers at cell (r,c)

% Exactly 2 airdrop locations
set of int: DROP = 1..2;

array[DROP] of var ROWS: drop_r;
array[DROP] of var COLS: drop_c;

% For each cell, assignment to either drop 1 or drop 2 (forced to 0 when huts=0)
array[ROWS, COLS] of var 0..1: assign1;
array[ROWS, COLS] of var 0..1: assign2;

% Max squared distance on an n x n grid
int: maxSq = 2 * (n - 1) * (n - 1);

% Precompute squared distances from every cell to every potential drop coordinate
array[ROWS, COLS, ROWS, COLS] of int: sqdist =
  array4d(ROWS, COLS, ROWS, COLS,
    [ (r - dr)*(r - dr) + (c - dc)*(c - dc)
    | r in ROWS, c in COLS, dr in ROWS, dc in COLS ]);

array[ROWS, COLS] of var 0..maxSq: cellCost;
var int: totalCost;

% Assignment constraints (only cells with huts are assigned)
constraint
  forall(r in ROWS, c in COLS) (
    if huts[r,c] > 0 then
      assign1[r,c] + assign2[r,c] = 1
    else
      assign1[r,c] = 0 /\ assign2[r,c] = 0
    endif
  );

% Enforce nearest-drop consistency (ties allowed) using precomputed distances
constraint
  forall(r in ROWS, c in COLS where huts[r,c] > 0) (
    (assign1[r,c] = 1 -> sqdist[r,c,drop_r[1],drop_c[1]] <= sqdist[r,c,drop_r[2],drop_c[2]]) /\
    (assign2[r,c] = 1 -> sqdist[r,c,drop_r[2],drop_c[2]] <= sqdist[r,c,drop_r[1],drop_c[1]])
  );

% Define per-cell squared distance to chosen drop (avoids var*var products)
constraint
  forall(r in ROWS, c in COLS) (
    cellCost[r,c] =
      assign1[r,c] * sqdist[r,c,drop_r[1],drop_c[1]] +
      assign2[r,c] * sqdist[r,c,drop_r[2],drop_c[2]]
  );

% Total weighted cost
constraint
  totalCost = sum(r in ROWS, c in COLS) (huts[r,c] * cellCost[r,c]);

% Symmetry breaking: lexicographic order of drop locations
constraint
  drop_r[1] < drop_r[2] \/
  (drop_r[1] = drop_r[2] /\ drop_c[1] <= drop_c[2]);

solve minimize totalCost;