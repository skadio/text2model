% Parameters
int: height;
int: width;
int: maxship;

array[1..width, 1..height] of int: hint;          % 0 unknown, 1 water, 2 ship (given)
array[1..width] of int: rowsum;
array[1..height] of int: colsum;
array[1..maxship] of int: ship;                  % ship[l] = number of ships of length l

set of int: X = 1..width;
set of int: Y = 1..height;
set of int: L = 1..maxship;
set of int: O = 1..2;                            % 1=horizontal, 2=vertical

int: maxShips = sum(l in L)(ship[l]);
set of int: S = 1..maxShips;

% Variables
array[S] of var 1..width: sx;                    % start x
array[S] of var 1..height: sy;                   % start y
array[S] of var 1..2: so;                        % orientation
array[S] of var 1..maxship: slen;                % length (will be linked to fleet)

array[X, Y] of var bool: occ;                    % occupied cell

% Constraints
% Bounds for ship placements inside the board
constraint
  forall(s in S)(
    (so[s] = 1 -> sx[s] + slen[s] - 1 <= width) /\
    (so[s] = 2 -> sy[s] + slen[s] - 1 <= height)
  );

% Fleet composition: exact counts per length
constraint
  forall(l in L)(
    sum(s in S)(bool2int(slen[s] = l)) = ship[l]
  );

% No overlap: each cell occupied by at most one ship segment
constraint
  forall(x in X, y in Y)(
    sum(s in S)(
      bool2int(
        (so[s] = 1 /\ sy[s] = y /\ sx[s] <= x /\ x <= sx[s] + slen[s] - 1) \/
        (so[s] = 2 /\ sx[s] = x /\ sy[s] <= y /\ y <= sy[s] + slen[s] - 1)
      )
    ) <= 1
  );

% Define occupancy grid (equivalence with "exactly one segment covers the cell")
constraint
  forall(x in X, y in Y)(
    occ[x,y] <-> (
      sum(s in S)(
        bool2int(
          (so[s] = 1 /\ sy[s] = y /\ sx[s] <= x /\ x <= sx[s] + slen[s] - 1) \/
          (so[s] = 2 /\ sx[s] = x /\ sy[s] <= y /\ y <= sy[s] + slen[s] - 1)
        )
      ) = 1
    )
  );

% No adjacency (including diagonal): occupied cells cannot touch each other
constraint
  forall(x in X, y in Y)(
    occ[x,y] ->
      forall(dx in -1..1, dy in -1..1 where not (dx = 0 /\ dy = 0))(
        let {
          int: nx = x + dx,
          int: ny = y + dy
        } in
          (nx < 1 \/ nx > width \/ ny < 1 \/ ny > height) \/ (not occ[nx,ny])
      )
  );

% Row and column sums
constraint
  forall(x in X)(
    sum(y in Y)(bool2int(occ[x,y])) = rowsum[x]
  );

constraint
  forall(y in Y)(
    sum(x in X)(bool2int(occ[x,y])) = colsum[y]
  );

% Hints: 0 unknown, 1 water, 2 ship
constraint
  forall(x in X, y in Y)(
    (hint[x,y] = 1 -> not occ[x,y]) /\
    (hint[x,y] = 2 -> occ[x,y])
  );

% Objective
solve satisfy;