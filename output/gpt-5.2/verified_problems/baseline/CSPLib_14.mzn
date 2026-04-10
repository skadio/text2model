int: height;
int: width;
int: maxship;

array[1..height, 1..width] of int: hint;
array[1..height] of int: rowsum;
array[1..width] of int: colsum;
array[1..maxship] of int: ship;

set of int: R = 1..height;
set of int: C = 1..width;

% Cell states:
% occ[r,c] = 1 iff occupied by any ship part.
array[R, C] of var 0..1: occ;

% Oriented ship-start variables:
% H[k,r,c] = 1 iff a length-k ship starts at (r,c) horizontally to the right
% V[k,r,c] = 1 iff a length-k ship starts at (r,c) vertically downward
array[1..maxship, R, C] of var 0..1: H;
array[1..maxship, R, C] of var 0..1: V;

% Helper: valid start positions
function var 0..1: inH(int: k, int: r, int: c) =
    if c + k - 1 <= width then H[k,r,c] else 0 endif;

function var 0..1: inV(int: k, int: r, int: c) =
    if r + k - 1 <= height then V[k,r,c] else 0 endif;

% Ship counts by length
constraint
  forall(k in 1..maxship) (
    sum(r in R, c in C)(inH(k,r,c) + inV(k,r,c)) = ship[k]
  );

% Link occupancy to ship placements:
% occ[r,c] equals the number of ship segments covering (r,c) (must be 0/1).
constraint
  forall(r in R, c in C) (
    occ[r,c] =
      sum(k in 1..maxship)(
        % covered by some horizontal ship of length k
        sum(s in 0..k-1)(
          if c - s >= 1 then inH(k, r, c - s) else 0 endif
        )
        +
        % covered by some vertical ship of length k
        sum(s in 0..k-1)(
          if r - s >= 1 then inV(k, r - s, c) else 0 endif
        )
      )
  );

% Ensure no cell is covered by more than one ship (already implied by occ in 0..1)
constraint
  forall(r in R, c in C)(
    sum(k in 1..maxship)(
      sum(s in 0..k-1)( if c - s >= 1 then inH(k, r, c - s) else 0 endif )
      +
      sum(s in 0..k-1)( if r - s >= 1 then inV(k, r - s, c) else 0 endif )
    ) <= 1
  );

% Row/column sums
constraint forall(r in R)( sum(c in C)(occ[r,c]) = rowsum[r] );
constraint forall(c in C)( sum(r in R)(occ[r,c]) = colsum[c] );

% No adjacency (including diagonals) between different ships:
% For each occupied cell, all 8-neighbors must be empty unless they are part of the same ship.
% Model via forbidding any two occupied cells at Chebyshev distance 1 unless aligned and connected.
% Easiest: enforce that any occupied cell cannot have occupied neighbors diagonally,
% and cannot have orthogonal occupied neighbors unless they are part of same ship segment chain.
% We implement stronger condition: forbid all diagonals always; allow orthogonals only if
% there exists a ship covering both cells.
array[R, C] of var bool: occb = array2d(R, C, [occ[r,c] = 1 | r in R, c in C]);

% Diagonals forbidden
constraint forall(r in R, c in C)(
  (r < height /\ c < width) -> (occ[r,c] + occ[r+1,c+1] <= 1)
);
constraint forall(r in R, c in C)(
  (r < height /\ c > 1) -> (occ[r,c] + occ[r+1,c-1] <= 1)
);

% Orthogonal adjacency must be within the same ship; we enforce via edge-compatibility.
% Define whether two adjacent cells are connected by a ship segment.
array[R, C] of var 0..1: connR; % connection to right (r,c) -- (r,c+1)
array[R, C] of var 0..1: connD; % connection down  (r,c) -- (r+1,c)

constraint forall(r in R, c in C)(
  connR[r,c] = if c < width then
    sum(k in 2..maxship)(
      sum(s in 0..k-2)(
        if c - s >= 1 then inH(k, r, c - s) else 0 endif
      )
    )
  else 0 endif
);

constraint forall(r in R, c in C)(
  connD[r,c] = if r < height then
    sum(k in 2..maxship)(
      sum(s in 0..k-2)(
        if r - s >= 1 then inV(k, r - s, c) else 0 endif
      )
    )
  else 0 endif
);

% If two orthogonally adjacent cells are both occupied, they must be connected.
constraint forall(r in R, c in C where c < width)(
  occ[r,c] + occ[r,c+1] - connR[r,c] <= 1
);
constraint forall(r in R, c in C where r < height)(
  occ[r,c] + occ[r+1,c] - connD[r,c] <= 1
);

% Also, if there is a connection, both ends must be occupied.
constraint forall(r in R, c in C where c < width)(
  connR[r,c] <= occ[r,c] /\ connR[r,c] <= occ[r,c+1]
);
constraint forall(r in R, c in C where r < height)(
  connD[r,c] <= occ[r,c] /\ connD[r,c] <= occ[r+1,c]
);

% Hints interpretation:
% hint values:
%  0 unknown
%  1 water (.)
%  2 ship segment (generic)
%  3 submarine (single)
%  4 left end  (<)
%  5 right end (>)
%  6 top end   (^)
%  7 bottom end(v)
%  8 middle    (o)
%
% If your .dzn uses different codes, adjust here accordingly.
int: UNKNOWN = 0;
int: WATER   = 1;
int: SHIPGEN = 2;
int: SUB     = 3;
int: LEFT    = 4;
int: RIGHT   = 5;
int: TOP     = 6;
int: BOTTOM  = 7;
int: MID     = 8;

% Water / generic ship hints
constraint forall(r in R, c in C)(
  (hint[r,c] == WATER) -> (occ[r,c] = 0)
);
constraint forall(r in R, c in C)(
  (hint[r,c] == SHIPGEN) -> (occ[r,c] = 1)
);

% Submarine: must be occupied and have no orthogonal neighbors occupied
constraint forall(r in R, c in C)(
  (hint[r,c] == SUB) -> (
    occ[r,c] = 1 /\
    (if r > 1 then occ[r-1,c] else 0 endif) = 0 /\
    (if r < height then occ[r+1,c] else 0 endif) = 0 /\
    (if c > 1 then occ[r,c-1] else 0 endif) = 0 /\
    (if c < width then occ[r,c+1] else 0 endif) = 0
  )
);

% End and middle hints enforce local connectivity pattern
constraint forall(r in R, c in C)(
  (hint[r,c] == LEFT) -> (
    occ[r,c] = 1 /\
    (if c < width then occ[r,c+1] else 0 endif) = 1 /\
    (if c > 1 then occ[r,c-1] else 0 endif) = 0 /\
    (if r > 1 then occ[r-1,c] else 0 endif) = 0 /\
    (if r < height then occ[r+1,c] else 0 endif) = 0
  )
);

constraint forall(r in R, c in C)(
  (hint[r,c] == RIGHT) -> (
    occ[r,c] = 1 /\
    (if c > 1 then occ[r,c-1] else 0 endif) = 1 /\
    (if c < width then occ[r,c+1] else 0 endif) = 0 /\
    (if r > 1 then occ[r-1,c] else 0 endif) = 0 /\
    (if r < height then occ[r+1,c] else 0 endif) = 0
  )
);

constraint forall(r in R, c in C)(
  (hint[r,c] == TOP) -> (
    occ[r,c] = 1 /\
    (if r < height then occ[r+1,c] else 0 endif) = 1 /\
    (if r > 1 then occ[r-1,c] else 0 endif) = 0 /\
    (if c > 1 then occ[r,c-1] else 0 endif) = 0 /\
    (if c < width then occ[r,c+1] else 0 endif) = 0
  )
);

constraint forall(r in R, c in C)(
  (hint[r,c] == BOTTOM) -> (
    occ[r,c] = 1 /\
    (if r > 1 then occ[r-1,c] else 0 endif) = 1 /\
    (if r < height then occ[r+1,c] else 0 endif) = 0 /\
    (if c > 1 then occ[r,c-1] else 0 endif) = 0 /\
    (if c < width then occ[r,c+1] else 0 endif) = 0
  )
);

constraint forall(r in R, c in C)(
  (hint[r,c] == MID) -> (
    occ[r,c] = 1 /\
    (
      % either horizontal middle (both left and right occupied, no vertical)
      (
        (if c > 1 then occ[r,c-1] else 0 endif) = 1 /\
        (if c < width then occ[r,c+1] else 0 endif) = 1 /\
        (if r > 1 then occ[r-1,c] else 0 endif) = 0 /\
        (if r < height then occ[r+1,c] else 0 endif) = 0
      )
      \/
      % or vertical middle (both up and down occupied, no horizontal)
      (
        (if r > 1 then occ[r-1,c] else 0 endif) = 1 /\
        (if r < height then occ[r+1,c] else 0 endif) = 1 /\
        (if c > 1 then occ[r,c-1] else 0 endif) = 0 /\
        (if c < width then occ[r,c+1] else 0 endif) = 0
      )
    )
  )
);

solve satisfy;

output [
  if c = 1 then "\n" else "" endif ++
  (if fix(occ[r,c]) = 1 then "#" else "." endif)
  | r in R, c in C
];