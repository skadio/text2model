% Cutting stock with at most 4 patterns, max 5 pieces per pipe, waste <= 100mm.
% Additional cost depends on pattern usage rank:
% most used: +0.1*pipe, 2nd: +0.2*pipe, 3rd: +0.3*pipe, 4th: +0.4*pipe.
% Objective: minimize total cost = (#pipes) + rank-dependent extras (in pipe units).

include "globals.mzn";

% ----------------------- Data -----------------------
int: L = 1850;           % raw pipe length (mm)
int: wasteMax = 100;     % max leftover per pattern (mm)
int: maxPieces = 5;      % max pieces cut from one raw pipe
int: K = 4;              % max number of patterns

int: T = 4;              % number of item types
set of int: TYPES = 1..T;
array[TYPES] of int: len = [290, 315, 350, 455];
array[TYPES] of int: dem = [15, 28, 21, 30];

% Upper bound on pipes: each pipe makes at least 1 demanded piece
int: Nmax = sum(dem);

% Costs in tenths of a pipe unit (avoid fractions):
% base pipe cost = 10 (i.e., 1.0)
% rank extras: 1,2,3,4 (i.e., 0.1,0.2,0.3,0.4)
array[1..K] of int: rankExtra10 = [1,2,3,4];

% ----------------------- Decision variables -----------------------
% Pattern p produces a[p,t] pieces of type t per pipe used with that pattern.
array[1..K, TYPES] of var 0..maxPieces: a;

% Number of raw pipes cut with pattern p
array[1..K] of var 0..Nmax: x;

% Pattern usage flag (1 if used)
array[1..K] of var 0..1: used;

% Leftover per pattern (mm) if used; otherwise forced to 0
array[1..K] of var 0..wasteMax: waste;

% Frequencies sorted descending for rank assignment
array[1..K] of var 0..Nmax: xs;   % sorted x values (nonincreasing)

% Assignment matrix: assign each pattern p to a unique rank r
array[1..K, 1..K] of var 0..1: assign;

% ----------------------- Constraints -----------------------

% Link used <-> x
constraint forall(p in 1..K)(
  x[p] <= Nmax * used[p] /\
  x[p] >= used[p]
);

% Pattern feasibility: total pieces <= maxPieces, length used within [L-wasteMax, L]
constraint forall(p in 1..K)(
  sum(t in TYPES)(a[p,t]) <= maxPieces /\
  sum(t in TYPES)(len[t] * a[p,t]) + waste[p] = L * used[p] /\
  waste[p] <= wasteMax * used[p]
);

% Demand fulfillment (can overproduce? Typically not desired; enforce exact)
constraint forall(t in TYPES)(
  sum(p in 1..K)(a[p,t] * x[p]) = dem[t]
);

% If a pattern is used, it must produce at least 1 piece
constraint forall(p in 1..K)(
  sum(t in TYPES)(a[p,t]) >= used[p]
);

% Symmetry breaking: order patterns by nonincreasing usage to reduce search
constraint forall(p in 1..K-1)( x[p] >= x[p+1] );

% Define sorted frequencies (redundant due to above but used for rank logic)
constraint forall(p in 1..K)( xs[p] = x[p] );
constraint forall(p in 1..K-1)( xs[p] >= xs[p+1] );

% Rank assignment:
% - each rank r is assigned to exactly one pattern
% - each pattern p gets exactly one rank
% - if patterns have same frequency, any tie-breaking is ok (cost depends on rank,
%   but ties can permute without changing feasibility; solver may pick any)
constraint forall(r in 1..K)(
  sum(p in 1..K)(assign[p,r]) = 1
);
constraint forall(p in 1..K)(
  sum(r in 1..K)(assign[p,r]) = 1
);

% Enforce that rank r corresponds to the r-th largest frequency.
% We connect assigned pattern's x to the sorted sequence xs.
constraint forall(r in 1..K)(
  sum(p in 1..K)(x[p] * assign[p,r]) = xs[r]
);

% Additional costs apply only to used patterns: if xs[r]=0 then no extra.
% We'll model extra cost per rank as rankExtra10[r] * (xs[r] > 0).
array[1..K] of var 0..1: rankUsed;
constraint forall(r in 1..K)( rankUsed[r] <-> (xs[r] > 0) );

% ----------------------- Objective -----------------------
% Total cost in tenths of a pipe unit:
% base: 10 * total pipes
% extra: sum_r rankExtra10[r] * rankUsed[r]
var 0..100000: totalCost10 =
  10 * sum(p in 1..K)(x[p]) + sum(r in 1..K)(rankExtra10[r] * rankUsed[r]);

solve minimize totalCost10;

% ----------------------- Output -----------------------
output [
  "Total cost (pipe units) = ", show(totalCost10/10.0), "\n",
  "Total raw pipes = ", show(sum(p in 1..K)(x[p])), "\n\n",
  "Patterns (up to 4):\n"
] ++
[
  "Pattern ", show(p), ": x=", show(x[p]),
  ", pieces=[", concat([ if t=1 then "" else ", " endif ++ show(a[p,t]) | t in TYPES ]), "]",
  " lengthsUsed=", show(sum(t in TYPES)(len[t]*a[p,t])),
  ", waste=", show(waste[p]), "\n"
  | p in 1..K
] ++
[
  "\nSorted usage xs (rank 1..4): [",
  concat([ if r=1 then "" else ", " endif ++ show(xs[r]) | r in 1..K ]),
  "]\n",
  "Rank used flags: [",
  concat([ if r=1 then "" else ", " endif ++ show(rankUsed[r]) | r in 1..K ]),
  "]\n"
];