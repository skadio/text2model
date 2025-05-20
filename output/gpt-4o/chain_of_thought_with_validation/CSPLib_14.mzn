% Parameters
int: height;
int: width;
int: maxship;

set of int: ROWS = 1..height;
set of int: COLS = 1..width;
set of int: LENGTHS = 1..maxship;
set of int: ORIENT = 1..2;          % 1 = horizontal, 2 = vertical

array[ROWS,COLS]        of int: hint;      % 0 = water, 1 = ship, others = unknown
array[ROWS]             of int: rowsum;    % row totals
array[COLS]             of int: colsum;    % column totals
array[LENGTHS]          of int: ship;      % fleet composition

% ----------------- build every possible ship placement -----------------
% number of placements
int: numPlacements =
   sum(l in LENGTHS)( height*(width-l+1) + width*(height-l+1) );

set of int: PLACEMENTS = 1..numPlacements;

% start-position/orientation/length description for each placement
array[PLACEMENTS] of int: plac_len =
      [ l | l in LENGTHS, r in ROWS, c in 1..width-l+1 ] ++
      [ l | l in LENGTHS, r in 1..height-l+1, c in COLS ];

array[PLACEMENTS] of int: plac_orient =
      [ 1 | l in LENGTHS, r in ROWS, c in 1..width-l+1 ] ++
      [ 2 | l in LENGTHS, r in 1..height-l+1, c in COLS ];

array[PLACEMENTS] of int: plac_row =
      [ r | l in LENGTHS, r in ROWS, c in 1..width-l+1 ] ++
      [ r | l in LENGTHS, r in 1..height-l+1, c in COLS ];

array[PLACEMENTS] of int: plac_col =
      [ c | l in LENGTHS, r in ROWS, c in 1..width-l+1 ] ++
      [ c | l in LENGTHS, r in 1..height-l+1, c in COLS ];

% Variables
array[PLACEMENTS]              of var bool: place;           % true  => ship is taken
array[ROWS,COLS]               of var 0..1: board;           % 1 = occupied by (some) ship part

% ----------------- helper predicate for placement conflicts ------------
predicate placements_conflict(int: p, int: q) =
   exists(i in 0..plac_len[p]-1,
          j in 0..plac_len[q]-1)(
        let {
            int: r1 = plac_row[p] + bool2int(plac_orient[p]=2)*i,
            int: c1 = plac_col[p] + bool2int(plac_orient[p]=1)*i,
            int: r2 = plac_row[q] + bool2int(plac_orient[q]=2)*j,
            int: c2 = plac_col[q] + bool2int(plac_orient[q]=1)*j
        } in
            abs(r1-r2) <= 1 /\ abs(c1-c2) <= 1
   );

% Constraints
% 1. Link placements to the board
constraint
   forall(r in ROWS, c in COLS)(
        board[r,c] =
          sum(p in PLACEMENTS where
               ( plac_orient[p] = 1 /\ r = plac_row[p] /\
                 c >= plac_col[p] /\ c < plac_col[p] + plac_len[p] )
            \/ ( plac_orient[p] = 2 /\ c = plac_col[p] /\
                 r >= plac_row[p] /\ r < plac_row[p] + plac_len[p] )
          )( bool2int(place[p]) )
   );

% 2. Row and column totals
constraint
   forall(r in ROWS)(
        sum(c in COLS)( board[r,c] ) = rowsum[r]
   );

constraint
   forall(c in COLS)(
        sum(r in ROWS)( board[r,c] ) = colsum[c]
   );

% 3. Fleet composition
constraint
   forall(l in LENGTHS)(
        sum(p in PLACEMENTS where plac_len[p] = l)( bool2int(place[p]) ) = ship[l]
   );

% 4. Ships may not touch (orthogonally or diagonally)
constraint
   forall(p in PLACEMENTS, q in PLACEMENTS where q > p /\ placements_conflict(p,q))(
        bool2int(place[p]) + bool2int(place[q]) <= 1
   );

% 5. Incorporate given hints
constraint
   forall(r in ROWS, c in COLS where hint[r,c] = 0)( board[r,c] = 0 );

constraint
   forall(r in ROWS, c in COLS where hint[r,c] = 1)( board[r,c] = 1 );

% Objective
solve satisfy;