% Parameters
int: r; % Number of rows in the grid
int: c; % Number of columns in the grid

array[1..r, 1..c] of int: puzzle; % Given Hidato grid (0 = empty, >0 = pre-filled)

% Derived parameters
int: nCells = r * c; % Total number of cells
int: maxGiven = max([puzzle[i,j] | i in 1..r, j in 1..c]); % Largest clue (0 if none)


% Variables
array[1..r, 1..c] of var 0..nCells: val; % Value in each cell; 0 means unused

% Position (row/col) of each number k
array[1..nCells] of var 1..r: pos_r;
array[1..nCells] of var 1..c: pos_c;

% Largest number used in the completed path
var maxGiven..nCells: N;


% Constraints

%-------------------------------
% Determine the size of the path
%-------------------------------
constraint N >= maxGiven;

%--------------------------------------------------------
% Link cell values <-> position variables (channeling)
%--------------------------------------------------------

% For each k <= N, some cell contains k.
constraint
  forall(k in 1..nCells) (
    (k <= N) -> exists(i in 1..r, j in 1..c) (val[i,j] = k)
  );

% Define pos_r[k], pos_c[k] as the coordinates of number k (for k <= N).
constraint
  forall(k in 1..nCells) (
    (k <= N) -> (val[pos_r[k], pos_c[k]] = k)
  );

% For k > N, positions are irrelevant; pin them to a fixed coordinate.
constraint
  forall(k in 1..nCells) (
    (k > N) -> (pos_r[k] = 1 /\ pos_c[k] = 1)
  );

% No two different numbers 1..N can occupy the same cell.
constraint
  forall(k1 in 1..nCells, k2 in 1..nCells where k1 < k2) (
    (k2 <= N) -> (pos_r[k1] != pos_r[k2] \/ pos_c[k1] != pos_c[k2])
  );

% Each cell contains either 0 (unused) or a number in 1..N.
constraint
  forall(i in 1..r, j in 1..c) (
    (val[i,j] = 0) \/ (val[i,j] >= 1 /\ val[i,j] <= N)
  );

%--------------------------------------------------------
% Respect given clues
%--------------------------------------------------------
constraint
  forall(i in 1..r, j in 1..c where puzzle[i,j] > 0) (
    val[i,j] = puzzle[i,j] /\ puzzle[i,j] <= N
  );

%--------------------------------------------------------
% Consecutive adjacency (Hidato path rule)
%--------------------------------------------------------
constraint
  forall(k in 1..nCells-1) (
    (k+1 <= N) ->
      (abs(pos_r[k+1] - pos_r[k]) <= 1 /\ abs(pos_c[k+1] - pos_c[k]) <= 1)
      /\ not (pos_r[k+1] = pos_r[k] /\ pos_c[k+1] = pos_c[k])
  );


% Objective
solve maximize N;