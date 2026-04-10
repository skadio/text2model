% Fill-a-Pix (Minesweeper-like) - Satisfaction model
int: n;

% Input grid: use -1 for unknown cells.
% If your .dzn currently uses X, replace X with -1 there.
array[1..n, 1..n] of int: puzzle;

% Decision variables: 1 if painted, 0 otherwise
array[1..n, 1..n] of var 0..1: painted;

% Clue constraints: for each clue cell, the number of painted cells in its 3x3 neighborhood
% (clipped at borders) equals the clue value.
constraint
  forall(r in 1..n, c in 1..n where puzzle[r,c] != -1) (
    let {
      int: rmin = if r > 1 then r - 1 else 1 endif,
      int: rmax = if r < n then r + 1 else n endif,
      int: cmin = if c > 1 then c - 1 else 1 endif,
      int: cmax = if c < n then c + 1 else n endif
    } in
      sum(rr in rmin..rmax, cc in cmin..cmax)(painted[rr,cc]) = puzzle[r,c]
  );

% Optional sanity check: clue must be feasible given neighborhood size
constraint
  forall(r in 1..n, c in 1..n where puzzle[r,c] != -1) (
    let {
      int: rmin = if r > 1 then r - 1 else 1 endif,
      int: rmax = if r < n then r + 1 else n endif,
      int: cmin = if c > 1 then c - 1 else 1 endif,
      int: cmax = if c < n then c + 1 else n endif,
      int: neigh_size = (rmax - rmin + 1) * (cmax - cmin + 1)
    } in
      puzzle[r,c] >= 0 /\ puzzle[r,c] <= neigh_size
  );

solve satisfy;