% Parameters
int: n;                                  % Grid size (rows = columns = n)
set of int: ROWS = 1..n;                 % Row index set
set of int: COLS = 1..n;                 % Column index set

array[ROWS, COLS] of int: huts;          % huts[r,c] = number of villagers at cell (r,c) (>= 0)

% Variables
array[1..2] of var ROWS: drop_r;         % Row coordinate of each of the 2 airdrop locations
array[1..2] of var COLS: drop_c;         % Column coordinate of each of the 2 airdrop locations

array[ROWS, COLS] of var 1..2: assign;   % For each cell (r,c), chosen nearest drop (ties allowed)

var int: total_squared_distance;         % Sum huts[r,c] * squared distance to assigned drop

% Constraints

%--- Exactly two distinct airdrop locations (no duplicate coordinates)
constraint (drop_r[1] != drop_r[2]) \/ (drop_c[1] != drop_c[2]);

%--- Nearest-drop assignment consistency (ties allowed)
constraint
  forall(r in ROWS, c in COLS) (
    let {
      var int: d1 = (r - drop_r[1])*(r - drop_r[1]) + (c - drop_c[1])*(c - drop_c[1]),
      var int: d2 = (r - drop_r[2])*(r - drop_r[2]) + (c - drop_c[2])*(c - drop_c[2])
    } in
      (assign[r,c] = 1 -> d1 <= d2) /\
      (assign[r,c] = 2 -> d2 <= d1)
  );

%--- Total squared distance definition (use bool2int to avoid coercion issues)
constraint
  total_squared_distance =
    sum(r in ROWS, c in COLS) (
      huts[r,c] *
      (
        bool2int(assign[r,c] = 1) *
          ( (r - drop_r[1])*(r - drop_r[1]) + (c - drop_c[1])*(c - drop_c[1]) ) +
        bool2int(assign[r,c] = 2) *
          ( (r - drop_r[2])*(r - drop_r[2]) + (c - drop_c[2])*(c - drop_c[2]) )
      )
    );

% Objective
solve minimize total_squared_distance;