% Parameters
int: height;
int: width;
int: maxship;

array[1..width, 1..height] of int: hint;          % expected codes: 0 unknown, 1 water, 2 ship
array[1..width] of int: rowsum;
array[1..height] of int: colsum;
array[1..maxship] of int: ship;                  % ship[len] = number of ships of length len

set of int: X = 1..width;
set of int: Y = 1..height;
set of int: L = 1..maxship;

% Variables
array[X, Y] of var 0..1: occ;                    % 1 if occupied by any ship cell

% startsH[x,y,l] = 1 if a horizontal ship of length l starts at (x,y)
% startsV[x,y,l] = 1 if a vertical ship of length l starts at (x,y)
array[X, Y, L] of var 0..1: startsH;
array[X, Y, L] of var 0..1: startsV;

% Constraints
% Basic bounds for starts outside feasible placements
constraint
  forall(x in X, y in Y, l in L where x + l - 1 > width) (
    startsH[x,y,l] = 0
  );

constraint
  forall(x in X, y in Y, l in L where y + l - 1 > height) (
    startsV[x,y,l] = 0
  );

% Fleet size: exact number of ships of each length
constraint
  forall(l in L) (
    sum(x in X, y in Y) (startsH[x,y,l] + startsV[x,y,l]) = ship[l]
  );

% No length-1 ship should be both horizontal and vertical (avoid double-encoding same ship)
constraint
  forall(x in X, y in Y) (
    startsH[x,y,1] + startsV[x,y,1] <= 1
  );

% Link occupancy to ship placements (exact cover)
constraint
  forall(x in X, y in Y) (
    occ[x,y] =
      sum(l in L)(
        % covered by a horizontal ship of length l starting at (xs,y) with xs in [x-l+1..x]
        sum(xs in X where xs <= x /\ x <= xs + l - 1 /\ xs + l - 1 <= width) (startsH[xs,y,l])
        +
        % covered by a vertical ship of length l starting at (x,ys) with ys in [y-l+1..y]
        sum(ys in Y where ys <= y /\ y <= ys + l - 1 /\ ys + l - 1 <= height) (startsV[x,ys,l])
      )
  );

% Ensure no cell is covered by more than one ship segment (redundant but strengthening)
constraint
  forall(x in X, y in Y) (
    sum(l in L)(
      sum(xs in X where xs <= x /\ x <= xs + l - 1 /\ xs + l - 1 <= width) (startsH[xs,y,l])
      +
      sum(ys in Y where ys <= y /\ y <= ys + l - 1 /\ ys + l - 1 <= height) (startsV[x,ys,l])
    ) <= 1
  );

% Row and column sums
constraint
  forall(y in Y) (
    sum(x in X) (occ[x,y]) = colsum[y]
  );

constraint
  forall(x in X) (
    sum(y in Y) (occ[x,y]) = rowsum[x]
  );

% No adjacency (including diagonals): for each occupied cell, all 8-neighbors must be empty
constraint
  forall(x in X, y in Y) (
    sum(dx in -1..1, dy in -1..1 where not (dx=0 /\ dy=0) /\
                               x+dx in X /\ y+dy in Y) (occ[x+dx, y+dy]) <= 8 * (1 - occ[x,y])
  );

% Apply hints: 0 unknown, 1 water, 2 ship
constraint
  forall(x in X, y in Y) (
    (hint[x,y] = 1 -> occ[x,y] = 0) /\
    (hint[x,y] = 2 -> occ[x,y] = 1)
  );

% Objective
solve satisfy;