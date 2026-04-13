include "globals.mzn";

%========================
% Input data
%========================
int: height;
int: width;
int: maxship;

array[1..height] of int: rowsum;
array[1..width]  of int: colsum;

% ship[L] = number of ships of length L (1..maxship)
array[1..maxship] of int: ship;

% hint board (codes):
% 0 = unknown
% 1 = water
% 2 = ship (occupied)
array[1..height, 1..width] of int: hint;

%========================
% Helper
%========================
function bool: inside(int:r, int:c) = r>=1 /\ r<=height /\ c>=1 /\ c<=width;

%========================
% Decision variables
%========================
array[1..height, 1..width] of var 0..1: occ;  % 1 iff ship occupies (r,c)

% For each ship length L, index k in 1..ship[L]:
% orient=0 horizontal, 1 vertical; (sr,sc) is start (top/left end)
array[1..maxship] of array[int] of var 0..1: orient =
  [ array[1..ship[L]] of var 0..1 | L in 1..maxship ];
array[1..maxship] of array[int] of var 1..height: sr =
  [ array[1..ship[L]] of var 1..height | L in 1..maxship ];
array[1..maxship] of array[int] of var 1..width: sc =
  [ array[1..ship[L]] of var 1..width | L in 1..maxship ];

%========================
% Row/column sums (from hint)
%========================
constraint forall(r in 1..height) (
  count([ occ[r,c] | c in 1..width ], 1, rowsum[r])
);
constraint forall(c in 1..width) (
  count([ occ[r,c] | r in 1..height ], 1, colsum[c])
);

%========================
% Apply given hints
%========================
constraint forall(r in 1..height, c in 1..width) (
  (hint[r,c] = 1 -> occ[r,c] = 0) /\
  (hint[r,c] = 2 -> occ[r,c] = 1)
);

%========================
% Ships must fit on board
%========================
constraint forall(L in 1..maxship, k in 1..ship[L]) (
  (orient[L][k] = 0 -> sc[L][k] <= width - L + 1) /\
  (orient[L][k] = 1 -> sr[L][k] <= height - L + 1)
);

%========================
% Link ships to occupancy:
% Every occupied cell must be covered by exactly one ship segment,
% and ships cover their own segments.
%========================
constraint forall(r in 1..height, c in 1..width) (
  occ[r,c] =
    sum(L in 1..maxship, k in 1..ship[L]) (
      bool2int(
        (orient[L][k] = 0 /\ r = sr[L][k] /\ c >= sc[L][k] /\ c <= sc[L][k] + L - 1) \/
        (orient[L][k] = 1 /\ c = sc[L][k] /\ r >= sr[L][k] /\ r <= sr[L][k] + L - 1)
      )
    )
);

%========================
% No adjacency (including diagonals) between different ships:
% For every ship-cell, all 8 neighbors must be water unless they are
% consecutive cells of the same ship.
%========================
constraint forall(L in 1..maxship, k in 1..ship[L], t in 0..L-1) (
  let {
    var int: r = sr[L][k] + (orient[L][k] = 1 ? t : 0),
    var int: c = sc[L][k] + (orient[L][k] = 0 ? t : 0)
  } in
  forall(dr in -1..1, dc in -1..1 where not (dr=0 /\ dc=0)) (
    let {
      int: rr = r + dr,
      int: cc = c + dc
    } in
    inside(rr,cc) ->
      (
        % Allow adjacency only for the next/prev segment of the same ship
        ( (orient[L][k] = 0 /\ dr = 0 /\ ((dc = 1 /\ t < L-1) \/ (dc = -1 /\ t > 0))) \/
          (orient[L][k] = 1 /\ dc = 0 /\ ((dr = 1 /\ t < L-1) \/ (dr = -1 /\ t > 0)))
        )
        \/
        occ[rr,cc] = 0
      )
  )
);

%========================
% Symmetry breaking: within same length, order ships by (sr,sc,orient)
%========================
constraint forall(L in 1..maxship, k in 1..ship[L]-1) (
  (sr[L][k] < sr[L][k+1]) \/
  (sr[L][k] = sr[L][k+1] /\ sc[L][k] < sc[L][k+1]) \/
  (sr[L][k] = sr[L][k+1] /\ sc[L][k] = sc[L][k+1] /\ orient[L][k] <= orient[L][k+1])
);

solve satisfy;

output
[
  if c=1 then "" else "" endif |
  r in 1..height,
  c in 1..width
]
++
[
  "Board (.:water, O:ship)\n"
]
++
[
  concat([ if fix(occ[r,c])=1 then "O" else "." endif | c in 1..width ]) ++ "\n"
  | r in 1..height
];