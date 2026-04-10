% Parameters
int: height;                               % Height of the board (number of rows)
int: width;                                % Width of the board (number of columns)
int: maxship;                              % Maximal ship length

array[1..width, 1..height] of int: hint;   % Given hints / initial board information
array[1..width] of int: rowsum;            % Number of occupied ship cells per row
array[1..height] of int: colsum;           % Number of occupied ship cells per column
array[1..maxship] of int: ship;            % ship[L] = number of ships of length L


% Variables
array[1..width, 1..height] of var 0..1: occ;     % occ[x,y]=1 if cell (x,y) is occupied by any ship

array[1..width, 1..height] of var 0..1: headH;   % headH[x,y]=1 if a horizontal ship starts at (x,y)
array[1..width, 1..height] of var 0..1: headV;   % headV[x,y]=1 if a vertical ship starts at (x,y)

array[1..width, 1..height] of var 0..maxship: shipLenH; % length of horizontal ship starting at (x,y), else 0
array[1..width, 1..height] of var 0..maxship: shipLenV; % length of vertical ship starting at (x,y), else 0


% Constraints

% --- Row and column occupancy sums (must match given totals) ---
constraint
  forall(y in 1..height) (
    sum(x in 1..width)(occ[x,y]) = rowsum[y]
  );

constraint
  forall(x in 1..width) (
    sum(y in 1..height)(occ[x,y]) = colsum[x]
  );

% --- Link ship lengths to heads (a length > 0 iff there is a head) ---
constraint
  forall(x in 1..width, y in 1..height) (
    (shipLenH[x,y] > 0) <-> (headH[x,y] = 1)
  );

constraint
  forall(x in 1..width, y in 1..height) (
    (shipLenV[x,y] > 0) <-> (headV[x,y] = 1)
  );

% --- A cell cannot be both a horizontal and vertical head ---
constraint
  forall(x in 1..width, y in 1..height) (
    headH[x,y] + headV[x,y] <= 1
  );

% --- Ships must fit on the board given their start and length ---
constraint
  forall(x in 1..width, y in 1..height) (
    (headH[x,y] = 1) -> (x + shipLenH[x,y] - 1 <= width)
  );

constraint
  forall(x in 1..width, y in 1..height) (
    (headV[x,y] = 1) -> (y + shipLenV[x,y] - 1 <= height)
  );

% --- Fleet composition: number of ships of each length (horizontal + vertical) ---
constraint
  forall(L in 1..maxship) (
      sum(x in 1..width, y in 1..height)(bool2int(shipLenH[x,y] = L))
    + sum(x in 1..width, y in 1..height)(bool2int(shipLenV[x,y] = L))
    = ship[L]
  );

% --- Occupancy definition: a cell is occupied iff covered by some ship segment ---
% Each cell can be covered by at most one segment (also prevents ship overlap).
% Note: occ is var 0..1, so the sum below is forced to be 0 or 1 (no overlap).
constraint
  forall(x in 1..width, y in 1..height) (
    occ[x,y] =
      sum(xs in 1..width)(
        bool2int(headH[xs,y] = 1 /\ shipLenH[xs,y] > 0 /\ xs <= x /\ x < xs + shipLenH[xs,y])
      )
    + sum(ys in 1..height)(
        bool2int(headV[x,ys] = 1 /\ shipLenV[x,ys] > 0 /\ ys <= y /\ y < ys + shipLenV[x,ys])
      )
  );

% Redundant but clarifies intent (no overlaps)
constraint
  forall(x in 1..width, y in 1..height) (
    occ[x,y] <= 1
  );

% --- No-adjacency rule: ships cannot touch orthogonally or diagonally ---
constraint
  forall(x in 1..width, y in 1..height) (
    occ[x,y] = 1 ->
      (
        % orthogonal neighbors
        (if x > 1 then occ[x-1,y] else 0 endif) +
        (if x < width then occ[x+1,y] else 0 endif) +
        (if y > 1 then occ[x,y-1] else 0 endif) +
        (if y < height then occ[x,y+1] else 0 endif) +
        % diagonal neighbors
        (if x > 1 /\ y > 1 then occ[x-1,y-1] else 0 endif) +
        (if x > 1 /\ y < height then occ[x-1,y+1] else 0 endif) +
        (if x < width /\ y > 1 then occ[x+1,y-1] else 0 endif) +
        (if x < width /\ y < height then occ[x+1,y+1] else 0 endif)
      ) = 0
  );

% --- Hints: enforce any known occupied/empty information from hint grid ---
% Assumption: hint[x,y] = 0 means water (empty), hint[x,y] = 1 means occupied.
% Other values are ignored.
constraint
  forall(x in 1..width, y in 1..height) (
    (hint[x,y] = 0 -> occ[x,y] = 0) /\
    (hint[x,y] = 1 -> occ[x,y] = 1)
  );


% Objective
solve satisfy;