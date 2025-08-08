include "globals.mzn";

%--- Input data ------------------------------------------------------------
int: height;                          % board height
int: width;                           % board width
int: maxship;                         % maximal ship length

array[1..height, 1..width] of int: hint;   % hint board: -1 unknown, 0 water, 1 ship
array[1..height] of int: rowsum;           % required number of ship cells per row
array[1..width] of int: colsum;            % required number of ship cells per column
array[1..maxship] of int: ship;            % number of ships of each length

%--- Derived data ----------------------------------------------------------
int: num_ships = sum(ship);      % total number of ships

% lengths of each individual ship (e.g. [5,5,4,3,3,2,...])
array[1..num_ships] of int: ship_len =
  [ l | l in 1..maxship, k in 1..ship[l] ];

%--- Decision variables ----------------------------------------------------
array[1..num_ships] of var 1..height: start_r;   % row of the leftmost/topmost cell
array[1..num_ships] of var 1..width:  start_c;   % column of the leftmost/topmost cell
array[1..num_ships] of var 0..1: orient;          % 0 = horizontal, 1 = vertical

% whether ship i occupies cell (r,c)
array[1..num_ships, 1..height, 1..width] of var bool: ship_occ;

% board cells (0 = water, 1 = ship part)
array[1..height, 1..width] of var 0..1: board;

%--- Constraints -----------------------------------------------------------

% 1. Ships fit inside the board
constraint forall(i in 1..num_ships) (
    (orient[i] == 0) -> (start_c[i] + ship_len[i] - 1 <= width)
    /\ (orient[i] == 1) -> (start_r[i] + ship_len[i] - 1 <= height)
);

% 2. Ship cells are exactly the cells of its straight segment
constraint forall(i in 1..num_ships, r in 1..height, c in 1..width) (
    ship_occ[i][r][c] == (
        (orient[i] == 0 /\ r == start_r[i] /\ c >= start_c[i] /\ c <= start_c[i] + ship_len[i] - 1)
        \/ (orient[i] == 1 /\ c == start_c[i] /\ r >= start_r[i] /\ r <= start_r[i] + ship_len[i] - 1)
    )
);

% 3. Each ship occupies the correct number of cells
constraint forall(i in 1..num_ships) (
    sum(r in 1..height, c in 1..width)(bool2int(ship_occ[i][r][c])) == ship_len[i]
);

% 4. No two ships overlap
constraint forall(r in 1..height, c in 1..width) (
    sum(i in 1..num_ships)(bool2int(ship_occ[i][r][c])) <= 1
);

% 5. No adjacency (orthogonal or diagonal) between different ships
constraint forall(i in 1..num_ships, j in i+1..num_ships,
                 r in 1..height, c in 1..width) (
    forall(dr in -1..1, dc in -1..1 where (dr != 0 \/ dc != 0)) (
        let
            int: nr = r + dr;
            int: nc = c + dc;
        in
            (ship_occ[i][r][c] /\ (nr >= 1 /\ nr <= height /\ nc >= 1 /\ nc <= width))
            -> not ship_occ[j][nr][nc]
    )
);

% 6. Board definition from ship occupancies
constraint forall(r in 1..height, c in 1..width) (
    board[r][c] == sum(i in 1..num_ships)(bool2int(ship_occ[i][r][c]))
);

% 7. Row sums match the given target
constraint forall(r in 1..height) (
    sum(c in 1..width)(board[r][c]) == rowsum[r]
);

% 8. Column sums match the given target
constraint forall(c in 1..width) (
    sum(r in 1..height)(board[r][c]) == colsum[c]
);

% 9. Hint constraints
constraint forall(r in 1..height, c in 1..width) (
    (hint[r][c] == 1) -> (board[r][c] == 1)
    /\ (hint[r][c] == 0) -> (board[r][c] == 0)
);

%--- Solve and output ------------------------------------------------------
solve satisfy;

output [
  "Board:\n",
  concat([ concat([ show(board[r][c]) ++ " " | c in 1..width]) ++ "\n" | r in 1..height ])
];