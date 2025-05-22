% Parameters
int: height;
int: width;
int: maxship;

array[1..height, 1..width] of int: hint;          % 0 = known water, 1 = known ship, any other value = unknown
array[1..height]              of int: rowsum;      % number of occupied cells in every row
array[1..width]               of int: colsum;      % number of occupied cells in every column
array[1..maxship]             of int: ship;        % fleet description – ship[l] = how many ships of length l

% --- derived data -----------------------------------------------------------
int: totalShips = sum(l in 1..maxship)(ship[l]);

array[1..totalShips] of int: lengthShip =
   [ l | l in 1..maxship, _ in 1..ship[l] ];

set of int: SHIPS = 1..totalShips;
set of int: ROWS  = 1..height;
set of int: COLS  = 1..width;

% Variables
array[SHIPS]            of var ROWS:  ship_row;          % bow (top-most / left-most) row
array[SHIPS]            of var COLS:  ship_col;          % bow column
array[SHIPS]            of var bool:  horizontal;        % true  = horizontal, false = vertical

array[ROWS, COLS]       of var 0..1: board;              % 1 = ship segment, 0 = water

% Constraints
%
% 1.  Place every ship completely inside the board
constraint
   forall(s in SHIPS) (
        (horizontal[s] -> ship_col[s] + lengthShip[s] - 1 <= width)
     /\ (not horizontal[s] -> ship_row[s] + lengthShip[s] - 1 <= height)
   );

% 2.  Link ship placements to the board grid and forbid overlaps
constraint
   forall(r in ROWS, c in COLS)(
      sum(s in SHIPS)(
         bool2int(
              ( horizontal[s] /\ ship_row[s] = r /\ c >= ship_col[s]
                               /\ c < ship_col[s] + lengthShip[s] )
           \/ ( not horizontal[s] /\ ship_col[s] = c /\ r >= ship_row[s]
                                /\ r < ship_row[s] + lengthShip[s] )
         )
      ) = board[r,c]
   );

% 3.  Row and column sums
constraint forall(r in ROWS)( sum(c in COLS)(board[r,c]) = rowsum[r] );
constraint forall(c in COLS)( sum(r in ROWS)(board[r,c]) = colsum[c] );

% 4.  Ships may not touch each other, even diagonally
constraint
   forall(r in ROWS, c in 1..width-1)( board[r,c] + board[r,c+1] <= 1 );
constraint
   forall(r in 1..height-1, c in COLS)( board[r,c] + board[r+1,c] <= 1 );
constraint
   forall(r in 1..height-1, c in 1..width-1)( board[r,c] + board[r+1,c+1] <= 1 );
constraint
   forall(r in 2..height, c in 1..width-1)( board[r,c] + board[r-1,c+1] <= 1 );

% 5.  Apply the given hints
constraint
   forall(r in ROWS, c in COLS)(
        (hint[r,c] = 1) -> board[r,c] = 1
   );
constraint
   forall(r in ROWS, c in COLS)(
        (hint[r,c] = 0) -> board[r,c] = 0
   );

% Objective
solve satisfy;