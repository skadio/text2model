include "globals.mzn";

% Parameters
int: L = 1850;                       % raw pipe length (mm)
int: max_patterns = 4;               % at most 4 cutting patterns used
int: max_pieces_per_pipe = 5;        % at most 5 pieces per raw pipe
int: max_leftover = 100;             % leftover per pattern (mm) <= 100

int: K = 4;                          % number of demanded item types
array[1..K] of int: len = [290, 315, 350, 455];
array[1..K] of int: dem = [15, 28, 21, 30];

% Upper bound on number of raw pipes needed (safe bound): each pipe yields at least 1 demanded piece
int: U = sum(i in 1..K)(dem[i]);

% Surcharge fractions (in tenths of raw pipe value) for ranks 1..4
array[1..max_patterns] of int: surcharge_tenths = [1, 2, 3, 4];

% A large-M for linking pattern usage and piece counts
int: BigM = U;

% Variables
% Pattern definition: how many pieces of each type cut in pattern p
array[1..max_patterns, 1..K] of var 0..max_pieces_per_pipe: a;

% Number of raw pipes cut with pattern p
array[1..max_patterns] of var 0..U: x;

% Whether pattern p is used
array[1..max_patterns] of var bool: usep;

% Leftover length for pattern p
array[1..max_patterns] of var 0..L: leftover;

% Total pieces per raw pipe in pattern p
array[1..max_patterns] of var 0..max_pieces_per_pipe: pieces;

% Ranking of patterns by usage frequency:
% order[r] = index of pattern in rank r (rank 1 = most used)
array[1..max_patterns] of var 1..max_patterns: order;

% Counts of pipes for the r-th ranked pattern (i.e., x[order[r]])
array[1..max_patterns] of var 0..U: xrank;

% Total cost in "raw pipe value" units with tenths precision:
% base cost: 10 per pipe, surcharge: rank r adds surcharge_tenths[r] per pipe of that ranked pattern
var 0..(10 + max(surcharge_tenths)) * U: total_cost_tenths;

% Constraints
% Link usep and x
constraint forall(p in 1..max_patterns) (
  x[p] <= BigM * bool2int(usep[p])
);
constraint forall(p in 1..max_patterns) (
  x[p] >= bool2int(usep[p])
);

% Pattern feasibility: piece count and length/leftover limits
constraint forall(p in 1..max_patterns) (
  pieces[p] = sum(i in 1..K)(a[p,i])
);
constraint forall(p in 1..max_patterns) (
  pieces[p] <= max_pieces_per_pipe
);

constraint forall(p in 1..max_patterns) (
  leftover[p] = L - sum(i in 1..K)(len[i] * a[p,i])
);
constraint forall(p in 1..max_patterns) (
  leftover[p] >= 0 /\ leftover[p] <= max_leftover
);

% If a pattern is not used, force it to be empty (helps avoid symmetry/noise)
constraint forall(p in 1..max_patterns, i in 1..K) (
  a[p,i] <= max_pieces_per_pipe * bool2int(usep[p])
);

% Demand satisfaction (meet or exceed demand)
constraint forall(i in 1..K) (
  sum(p in 1..max_patterns)(a[p,i] * x[p]) >= dem[i]
);

% At most 4 patterns are already modeled; allow fewer via usep
constraint sum(p in 1..max_patterns)(bool2int(usep[p])) <= max_patterns;

% Ranking constraints: order is a permutation of patterns
constraint all_different(order);

% Define xrank[r] = x[order[r]]
constraint forall(r in 1..max_patterns) (
  xrank[r] = x[order[r]]
);

% Enforce non-increasing usage with rank (rank 1 most frequent)
constraint forall(r in 1..max_patterns-1) (
  xrank[r] >= xrank[r+1]
);

% Compute total cost in tenths:
% base = 10 * total pipes; surcharge = sum_r surcharge_tenths[r] * xrank[r]
constraint total_cost_tenths =
  10 * sum(p in 1..max_patterns)(x[p]) +
  sum(r in 1..max_patterns)(surcharge_tenths[r] * xrank[r]);

% Objective
solve minimize total_cost_tenths;

% Output
output [
  "total_cost_tenths = ", show(total_cost_tenths), "\n",
  "total_pipes = ", show(sum(p in 1..max_patterns)(x[p])), "\n\n",
  "Patterns (p: x[p], pieces per type [290,315,350,455], leftover):\n",
  concat([ "p=" ++ show(p) ++
           " x=" ++ show(x[p]) ++
           " a=" ++ show([a[p,i] | i in 1..K]) ++
           " leftover=" ++ show(leftover[p]) ++ "\n"
           | p in 1..max_patterns ]),
  "\nRanking (rank r -> pattern index, x):\n",
  concat([ "r=" ++ show(r) ++ " -> p=" ++ show(order[r]) ++ " x=" ++ show(xrank[r]) ++ "\n"
           | r in 1..max_patterns ])
];