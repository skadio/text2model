include "globals.mzn";

% Parameters
int: r; % number of rows in the Hidato grid (given in .dzn)
int: c; % number of columns in the Hidato grid (given in .dzn)

array[1..r, 1..c] of int: puzzle; % given grid: 0 = empty cell, >0 = pre-filled number

% Useful derived parameters
int: N = r * c; % total number of cells (upper bound on values)

set of int: ROWS = 1..r;
set of int: COLS = 1..c;

% Variables
array[ROWS, COLS] of var 1..N: x; % value placed in each cell (filled to form consecutive path)

% Helper variables: min/max value present in the grid
var 1..N: start_val;
var 1..N: end_val;

%------------------------------------------------------------
% Fixed clues: pre-filled numbers must be respected
%------------------------------------------------------------
constraint
  forall(i in ROWS, j in COLS where puzzle[i,j] > 0) (
    x[i,j] = puzzle[i,j]
  );

%------------------------------------------------------------
% Determine start and end values from the grid (not assumed 1..N)
%------------------------------------------------------------
constraint start_val = min([ x[i,j] | i in ROWS, j in COLS ]);
constraint end_val   = max([ x[i,j] | i in ROWS, j in COLS ]);

%------------------------------------------------------------
% All numbers are used exactly once (Hamiltonian path labeling)
%------------------------------------------------------------
constraint
  all_different([ x[i,j] | i in ROWS, j in COLS ]);

%------------------------------------------------------------
% Consecutive adjacency:
% Each value v (except end_val) must have a neighbor with v+1,
% and each value v (except start_val) must have a neighbor with v-1.
% Neighbors include horizontal/vertical/diagonal adjacency.
%------------------------------------------------------------
constraint
  forall(i in ROWS, j in COLS) (
    let {
      var int: v = x[i,j],
      array[int] of var int: neigh =
        [ x[ii,jj]
        | ii in max(1,i-1)..min(r,i+1),
          jj in max(1,j-1)..min(c,j+1)
        where not (ii = i /\ jj = j)
        ]
    } in
      ( v < end_val   -> exists(k in index_set(neigh)) (neigh[k] = v + 1) ) /\
      ( v > start_val -> exists(k in index_set(neigh)) (neigh[k] = v - 1) )
  );

solve satisfy;