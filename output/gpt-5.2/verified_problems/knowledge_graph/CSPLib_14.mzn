include "globals.mzn";

int: height;
int: width;
int: maxship;

array[1..height, 1..width] of int: hint;   % convention:
% -1 = unknown, 0 = guaranteed water, 1 = guaranteed ship

array[1..height] of int: rowsum;
array[1..width]  of int: colsum;

array[1..maxship] of int: ship; % ship[L] = number of ships of length L

set of int: R = 1..height;
set of int: C = 1..width;
set of int: LENS = 1..maxship;

% Board occupancy
array[R, C] of var bool: occ;

% Enforce hints (if provided with -1/0/1 convention)
constraint
  forall(r in R, c in C) (
    (hint[r,c] = -1) \/
    (hint[r,c] = 0 /\ occ[r,c] = false) \/
    (hint[r,c] = 1 /\ occ[r,c] = true)
  );

% Row/column sums
constraint forall(r in R) (sum(c in C)(bool2int(occ[r,c])) = rowsum[r]);
constraint forall(c in C) (sum(r in R)(bool2int(occ[r,c])) = colsum[c]);

% No diagonal adjacency between occupied cells
constraint
  forall(r in R, c in C where r < height /\ c < width) (
    bool2int(occ[r,c]) + bool2int(occ[r+1,c+1]) <= 1
  );
constraint
  forall(r in R, c in C where r < height /\ c > 1) (
    bool2int(occ[r,c]) + bool2int(occ[r+1,c-1]) <= 1
  );

% Ship placement via selecting exact ships as horizontal/vertical segments.
% Start variables:
% h[r,c,L]=1 if a horizontal ship of length L starts at (r,c) going right
% v[r,c,L]=1 if a vertical ship of length L starts at (r,c) going down
array[R, C, LENS] of var bool: h;
array[R, C, LENS] of var bool: v;

% Disallow starts that would go out of bounds
constraint forall(r in R, c in C, L in LENS where c + L - 1 > width) (h[r,c,L] = false);
constraint forall(r in R, c in C, L in LENS where r + L - 1 > height) (v[r,c,L] = false);

% Exact number of ships of each length
constraint forall(L in LENS) (
  sum(r in R, c in C)(bool2int(h[r,c,L]) + bool2int(v[r,c,L])) = ship[L]
);

% Link occupancy to placements: each occupied cell is covered by exactly one ship segment
constraint
  forall(r in R, c in C) (
    bool2int(occ[r,c]) =
      sum(L in LENS)(
        % covered by a horizontal ship of length L starting at (r, c-k)
        sum(k in 0..L-1 where c-k >= 1)(
          bool2int(h[r, c-k, L])
        )
        +
        % covered by a vertical ship of length L starting at (r-k, c)
        sum(k in 0..L-1 where r-k >= 1)(
          bool2int(v[r-k, c, L])
        )
      )
  );

% No (orthogonal or diagonal) adjacency between distinct ships:
% Enforce a 1-cell water border around every placed ship segment.
% For each cell, if it is occupied then its neighbors (8-neighborhood) that are not
% part of the same ship would need extra tracking. Instead, we enforce a stronger
% but correct condition: any neighbor of an occupied cell may be occupied only if it
% can be explained as being in the same ship. Achieve by counting coverings on neighbors
% and requiring that any two orthogonally adjacent occupied cells must be aligned and
% belong to some common ship placement; diagonal already forbidden above.

% Orthogonal adjacency allowed only within a ship (same row or same col).
% If two adjacent cells are both occupied, then they must be covered by at least one
% common horizontal (for left-right) or common vertical (for up-down) placement.

% Helper: whether two cells share a common horizontal ship placement
function var bool: share_h(int: r, int: c1, int: c2) =
  exists(L in LENS)(
    exists(s in 1..width)(
      (c1 >= s /\ c1 <= s+L-1) /\ (c2 >= s /\ c2 <= s+L-1) /\
      (s+L-1 <= width) /\
      h[r,s,L]
    )
  );

% Helper: whether two cells share a common vertical ship placement
function var bool: share_v(int: c, int: r1, int: r2) =
  exists(L in LENS)(
    exists(s in 1..height)(
      (r1 >= s /\ r1 <= s+L-1) /\ (r2 >= s /\ r2 <= s+L-1) /\
      (s+L-1 <= height) /\
      v[s,c,L]
    )
  );

% Left-right adjacency constraint
constraint
  forall(r in R, c in 1..width-1) (
    (occ[r,c] /\ occ[r,c+1]) -> share_h(r,c,c+1)
  );

% Up-down adjacency constraint
constraint
  forall(r in 1..height-1, c in C) (
    (occ[r,c] /\ occ[r+1,c]) -> share_v(c,r,r+1)
  );

% Additionally forbid "T" and "+" junctions by limiting degree:
% each occupied cell can have at most 2 orthogonal occupied neighbors.
constraint
  forall(r in R, c in C) (
    sum(d in 1..4)(
      let {
        int: rr = if d=1 then r-1 else if d=2 then r+1 else r endif,
        int: cc = if d=3 then c-1 else if d=4 then c+1 else c endif
      } in
        bool2int(rr in R /\ cc in C /\ occ[rr,cc])
    ) <= 2
  );

solve satisfy;

output [
  if c=1 then "" else " " endif ++
  (if fix(occ[r,c]) then "O" else "." endif)
  ++ (if c=width then "\n" else "" endif)
  | r in R, c in C
];