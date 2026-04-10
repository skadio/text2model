% Solitaire Battleships (satisfaction)

% Parameters
int: height;
int: width;
int: maxship;

array[1..width, 1..height] of int: hint;   % 0=unknown, 1=water, 2=ship
array[1..width] of int: rowsum;            % per x (column index in this model)
array[1..height] of int: colsum;           % per y (row index in this model)
array[1..maxship] of int: ship;            % ship[l] = number of ships of length l

set of int: W = 1..width;
set of int: H = 1..height;
set of int: L = 1..maxship;

% Variables
array[W, H] of var 0..1: occ;

array[L, W, H] of var 0..1: useH;          % length l ship horizontal starting at (x,y)
array[L, W, H] of var 0..1: useV;          % length l ship vertical   starting at (x,y)

% --- Constraints ---

% Edge feasibility for placements
constraint
  forall(l in L, x in W, y in H) (
    (useH[l,x,y] = 1 -> x + l - 1 <= width) /\
    (useV[l,x,y] = 1 -> y + l - 1 <= height)
  );

% Fleet composition
constraint
  forall(l in L) (
    sum(x in W, y in H)(useH[l,x,y] + useV[l,x,y]) = ship[l]
  );

% Occupancy induced by placed ships + no overlap (exactly equals number of coverings, which is <=1)
constraint
  forall(x in W, y in H) (
    occ[x,y] =
      sum(l in L, sx in W where sx <= x /\ x <= sx + l - 1)(
        useH[l,sx,y]
      )
    +
      sum(l in L, sy in H where sy <= y /\ y <= sy + l - 1)(
        useV[l,x,sy]
      )
  );

% No overlap (at most one ship covers any cell)
constraint
  forall(x in W, y in H) (
    occ[x,y] <= 1
  );

% Row/column sums (as given by parameter shapes)
constraint forall(y in H) (sum(x in W)(occ[x,y]) = colsum[y]);
constraint forall(x in W) (sum(y in H)(occ[x,y]) = rowsum[x]);

% Non-adjacency (including diagonals), but allow orthogonal adjacency within the same ship.
constraint
  forall(x in W, y in H, dx in -1..1, dy in -1..1
         where not (dx = 0 /\ dy = 0)) (
    let {
      int: x2 = x + dx,
      int: y2 = y + dy
    } in
      (x2 >= 1 /\ x2 <= width /\ y2 >= 1 /\ y2 <= height) ->
        (
          occ[x,y] + occ[x2,y2] <= 1
          \/
          (
            (abs(dx) + abs(dy) = 1) /\
            (
              % same horizontal ship covers both
              exists(l in L, sx in W where sx + l - 1 <= width)(
                useH[l,sx,y] = 1 /\
                sx <= min(x,x2) /\ max(x,x2) <= sx + l - 1 /\
                y2 = y
              )
              \/
              % same vertical ship covers both
              exists(l in L, sy in H where sy + l - 1 <= height)(
                useV[l,x,sy] = 1 /\
                sy <= min(y,y2) /\ max(y,y2) <= sy + l - 1 /\
                x2 = x
              )
            )
          )
        )
  );

% Hints
constraint
  forall(x in W, y in H) (
    (hint[x,y] = 1 -> occ[x,y] = 0) /\
    (hint[x,y] = 2 -> occ[x,y] = 1)
  );

solve satisfy;