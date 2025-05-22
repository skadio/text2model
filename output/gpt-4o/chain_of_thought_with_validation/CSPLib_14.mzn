% ---------------------------------------------------------------------------
% Parameters
% ---------------------------------------------------------------------------
int: height;
int: width;
int: maxship;

% 0 = unknown, 1 = known water, 2 = known ship
array [1..height, 1..width] of int: hint;

array [1..height] of int: rowsum;          % occupied squares in each row
array [1..width]  of int: colsum;          % occupied squares in each column

array [1..maxship] of int: ship;           % ship[l] = number of ships of length l


% ---------------------------------------------------------------------------
% Basic sets
% ---------------------------------------------------------------------------
set of int: Rows    = 1..height;
set of int: Cols    = 1..width;
set of int: Lengths = 1..maxship;


% ---------------------------------------------------------------------------
% Decision variables
% ---------------------------------------------------------------------------
array [Rows, Cols] of var 0..1: ship_cell;              % 1 = ship, 0 = water

array [Lengths, Rows, Cols] of var bool: place_h;       % horizontal ships
array [Lengths, Rows, Cols] of var bool: place_v;       % vertical   ships


% ---------------------------------------------------------------------------
% 1.  Disable placements that do not fit completely on the board
% ---------------------------------------------------------------------------
constraint
  forall(l in Lengths, r in Rows, c in Cols where c > width  - l + 1) (
        not place_h[l,r,c]
  );

constraint
  forall(l in Lengths, r in Rows, c in Cols where r > height - l + 1) (
        not place_v[l,r,c]
  );

% Length-1 ships only counted once (horizontal)
constraint forall(r in Rows, c in Cols)( not place_v[1,r,c] );


% ---------------------------------------------------------------------------
% 2.  Relation between placements and occupied cells
% ---------------------------------------------------------------------------
constraint
  forall(rr in Rows, cc in Cols)(
        ship_cell[rr,cc] =
          sum(l in Lengths, c in Cols where c <= cc /\ cc <= c + l - 1)(
                bool2int(place_h[l, rr, c])
          )
        +
          sum(l in Lengths, r in Rows where r <= rr /\ rr <= r + l - 1)(
                bool2int(place_v[l, r, cc])
          )
  );

% no overlap (already implied, but kept for clarity)
constraint
  forall(rr in Rows, cc in Cols)(
        ship_cell[rr,cc] <= 1
  );


% ---------------------------------------------------------------------------
% 3.  Fleet composition
% ---------------------------------------------------------------------------
constraint
  forall(l in Lengths)(
        sum(r in Rows, c in Cols)( bool2int(place_h[l,r,c]) ) +
        sum(r in Rows, c in Cols)( bool2int(place_v[l,r,c]) ) = ship[l]
  );


% ---------------------------------------------------------------------------
% 4.  Surrounding-water constraints
%      (ships are straight and never adjacent, even diagonally)
% ---------------------------------------------------------------------------

% 4a. Horizontal ships ------------------------------------------------------

% occupied cells
constraint
  forall(l in Lengths, r in Rows, c in Cols, k in 0..l-1
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r, c+k] = 1
  );

% cells directly above
constraint
  forall(l in Lengths, r in 2..height, c in Cols, k in 0..l-1
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r-1, c+k] = 0
  );

% cells directly below
constraint
  forall(l in Lengths, r in 1..height-1, c in Cols, k in 0..l-1
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r+1, c+k] = 0
  );

% cell immediately left
constraint
  forall(l in Lengths, r in Rows, c in 2..width, 
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r, c-1] = 0
  );

% cell immediately right
constraint
  forall(l in Lengths, r in Rows, c in Cols
         where c + l - 1 < width)(
        place_h[l,r,c] -> ship_cell[r, c+l] = 0
  );

% diagonals at left end
constraint
  forall(l in Lengths, r in 2..height, c in 2..width
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r-1, c-1] = 0
  );
constraint
  forall(l in Lengths, r in 1..height-1, c in 2..width
         where c + l - 1 <= width)(
        place_h[l,r,c] -> ship_cell[r+1, c-1] = 0
  );

% diagonals at right end
constraint
  forall(l in Lengths, r in 2..height, c in Cols
         where c + l - 1 < width)(
        place_h[l,r,c] -> ship_cell[r-1, c+l] = 0
  );
constraint
  forall(l in Lengths, r in 1..height-1, c in Cols
         where c + l - 1 < width)(
        place_h[l,r,c] -> ship_cell[r+1, c+l] = 0
  );


% 4b. Vertical ships --------------------------------------------------------

% occupied cells
constraint
  forall(l in Lengths, r in Rows, c in Cols, k in 0..l-1
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r+k, c] = 1
  );

% cells directly left
constraint
  forall(l in Lengths, r in Rows, c in 2..width, k in 0..l-1
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r+k, c-1] = 0
  );

% cells directly right
constraint
  forall(l in Lengths, r in Rows, c in 1..width-1, k in 0..l-1
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r+k, c+1] = 0
  );

% cell immediately above
constraint
  forall(l in Lengths, r in 2..height, c in Cols
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r-1, c] = 0
  );

% cell immediately below
constraint
  forall(l in Lengths, r in Rows, c in Cols
         where r + l - 1 < height)(
        place_v[l,r,c] -> ship_cell[r+l, c] = 0
  );

% diagonals at top end
constraint
  forall(l in Lengths, r in 2..height, c in 2..width
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r-1, c-1] = 0
  );
constraint
  forall(l in Lengths, r in 2..height, c in 1..width-1
         where r + l - 1 <= height)(
        place_v[l,r,c] -> ship_cell[r-1, c+1] = 0
  );

% diagonals at bottom end
constraint
  forall(l in Lengths, r in Rows, c in 2..width
         where r + l - 1 < height)(
        place_v[l,r,c] -> ship_cell[r+l, c-1] = 0
  );
constraint
  forall(l in Lengths, r in Rows, c in 1..width-1
         where r + l - 1 < height)(
        place_v[l,r,c] -> ship_cell[r+l, c+1] = 0
  );


% ---------------------------------------------------------------------------
% 5.  Row and column sums
% ---------------------------------------------------------------------------
constraint
  forall(r in Rows)(
        sum(c in Cols)( ship_cell[r,c] ) = rowsum[r]
  );

constraint
  forall(c in Cols)(
        sum(r in Rows)( ship_cell[r,c] ) = colsum[c]
  );


% ---------------------------------------------------------------------------
% 6.  Apply given hints
% ---------------------------------------------------------------------------
constraint
  forall(r in Rows, c in Cols where hint[r,c] = 1)(
        ship_cell[r,c] = 0
  );

constraint
  forall(r in Rows, c in Cols where hint[r,c] = 2)(
        ship_cell[r,c] = 1
  );


% ---------------------------------------------------------------------------
% Objective
% ---------------------------------------------------------------------------
solve satisfy;