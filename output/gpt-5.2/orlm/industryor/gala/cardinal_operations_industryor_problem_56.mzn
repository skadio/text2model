include "globals.mzn";

/*
  Paper roll cutting to satisfy orders with minimal waste area.

  Orders (width w_i, required length L_i):
    1: 0.5 m, 1000 m
    2: 0.7 m, 3000 m
    3: 0.9 m, 2000 m

  Stock roll widths: 1 m and 2 m. Length is unlimited and can be spliced.
  We choose cutting "patterns" across the roll width; each pattern produces
  strips of various order-widths along some produced length.
  Waste area = (unused width in pattern) * (length produced with that pattern).
*/

int: nOrders = 3;
set of int: O = 1..nOrders;

% Use millimeters to avoid floats: 0.5,0.7,0.9 => 500,700,900 mm.
array[O] of int: w = [500, 700, 900];          % order widths (mm)
array[O] of int: L = [1000, 3000, 2000];       % required lengths (m)

int: nStocks = 2;
set of int: S = 1..nStocks;
array[S] of int: stockW = [1000, 2000];        % stock widths (mm)

% Enumerate all feasible cutting patterns for each stock width:
% A pattern is counts a[i] of each order width i across the roll width.
% For width 1m: max counts are small; for 2m: still small.
int: maxA1 = stockW[2] div w[1];   % for 0.5m => 2000/500 = 4
int: maxA2 = stockW[2] div w[2];   % => 2
int: maxA3 = stockW[2] div w[3];   % => 2

set of int: A1 = 0..maxA1;
set of int: A2 = 0..maxA2;
set of int: A3 = 0..maxA3;

% Build pattern lists (constants) with a fixed upper bound.
% We will include patterns that fit in 1m or 2m (i.e., width <= 2m),
% and then restrict which patterns can be used for each stock width.
int: Pmax = card(A1) * card(A2) * card(A3) - 1; % excluding all-zero
set of int: P = 1..Pmax;

array[P] of int: a1 =
  [ i | i in A1, j in A2, k in A3 where i + j + k > 0 ];
array[P] of int: a2 =
  [ j | i in A1, j in A2, k in A3 where i + j + k > 0 ];
array[P] of int: a3 =
  [ k | i in A1, j in A2, k in A3 where i + j + k > 0 ];

array[P] of int: usedW = [a1[p]*w[1] + a2[p]*w[2] + a3[p]*w[3] | p in P];

% Feasibility for stock widths
array[P] of bool: fits1 = [ usedW[p] <= stockW[1] | p in P ];
array[P] of bool: fits2 = [ usedW[p] <= stockW[2] | p in P ];

% Waste width for each stock type and pattern (mm)
array[P] of int: wasteW1 = [ stockW[1] - usedW[p] | p in P ];
array[P] of int: wasteW2 = [ stockW[2] - usedW[p] | p in P ];

/*
  Decision variables:
    x[s,p] = length (m) produced using stock width s and pattern p.
  This yields produced length for order i:
    sum_{s,p} x[s,p] * a_i[p]  >=  L[i]
  Objective: minimize total waste area (mm*m), i.e.
    sum_{p} x[1,p]*wasteW1[p] + sum_{p} x[2,p]*wasteW2[p]
*/
int: UB = sum(i in O)(L[i]); % safe upper bound on any produced length

array[S, P] of var 0..UB: x;

% Disallow using patterns that don't fit the chosen stock width.
constraint forall(p in P)(
  (not fits1[p]) -> x[1,p] = 0
);
constraint forall(p in P)(
  (not fits2[p]) -> x[2,p] = 0
);

% Demand satisfaction
constraint
  forall(i in O)(
    sum(s in S, p in P)(
      x[s,p] * ( if i=1 then a1[p] else if i=2 then a2[p] else a3[p] endif endif )
    ) >= L[i]
  );

% Objective: minimize waste area (mm*m). (A constant factor converts to m^2 if desired.)
var int: totalWaste =
  sum(p in P)( x[1,p] * wasteW1[p] ) + sum(p in P)( x[2,p] * wasteW2[p] );

solve minimize totalWaste;

% Helpful derived totals
array[O] of var int: producedLen =
  [ sum(s in S, p in P)( x[s,p] * (if i=1 then a1[p] else if i=2 then a2[p] else a3[p] endif endif) )
  | i in O ];

output
[
  "Total waste (mm*m) = ", show(totalWaste), "\n",
  "Produced lengths (m) per order = ", show(producedLen), "\n\n",
  "Nonzero pattern usages:\n"
]
++
[
  if fix(x[s,p]) > 0 then
    "  stock " ++ show(stockW[s]) ++ "mm, pattern [" ++
    show(a1[p]) ++ "x" ++ show(w[1]) ++ "mm, " ++
    show(a2[p]) ++ "x" ++ show(w[2]) ++ "mm, " ++
    show(a3[p]) ++ "x" ++ show(w[3]) ++ "mm], usedW=" ++ show(usedW[p]) ++
    "mm, wasteW=" ++ show((if s=1 then wasteW1[p] else wasteW2[p] endif)) ++
    "mm: length=" ++ show(x[s,p]) ++ "m\n"
  else
    ""
  endif
  | s in S, p in P
];