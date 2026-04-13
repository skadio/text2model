include "globals.mzn";

% -------------------------------
% Data (embedded from description)
% -------------------------------
int: RawLen = 1850;
int: MaxPatterns = 4;
int: MaxPiecesPerPipe = 5;
int: MaxWaste = 100;

set of int: T = 1..4;                       % item types
array[T] of int: len = [290, 315, 350, 455];
array[T] of int: demand = [15, 28, 21, 30];

% Upper bound on number of pipes: cut at least 1 demanded piece per pipe
int: N = sum(demand);

% -------------------------------
% Decision variables
% -------------------------------
% Pattern definitions: pieces of each type produced by each pattern
array[1..MaxPatterns, T] of var 0..MaxPiecesPerPipe: pat;

% Waste (leftover) for each pattern
array[1..MaxPatterns] of var 0..MaxWaste: waste;

% Assign each (potential) pipe to one of the MaxPatterns
array[1..N] of var 1..MaxPatterns: pat_of_pipe;

% Usage frequency for each pattern
array[1..MaxPatterns] of var 0..N: use;

% Total produced pieces (must meet demand exactly)
array[T] of var 0..N*MaxPiecesPerPipe: produced;

% Number of patterns used
array[1..MaxPatterns] of var bool: used;
var 0..MaxPatterns: nUsed;

% Rank of each pattern by frequency: rank[p]=1 means most used, etc.
array[1..MaxPatterns] of var 1..MaxPatterns: rank;

% Extra-cost index for each pipe = rank of its assigned pattern
array[1..N] of var 1..MaxPatterns: costIdx;

% Total cost scaled by 10 to avoid fractions:
% base pipe cost = 10 per pipe; extra for rank r = r (i.e., r/10 of a pipe).
var 0..(10+MaxPatterns)*N: totalCost10;

% -------------------------------
% Constraints: pattern feasibility
% -------------------------------
constraint forall(p in 1..MaxPatterns) (
  let {
    var int: pieces = sum(t in T)(pat[p,t]),
    var int: usedLen = sum(t in T)(pat[p,t] * len[t])
  } in
    pieces <= MaxPiecesPerPipe /\
    pieces >= 1 /\                         % if pattern is used, it should make at least 1 piece (handled with used<->use below)
    usedLen + waste[p] = RawLen /\          % define waste
    waste[p] <= MaxWaste                   % waste limit
);

% If a pattern is not used, force it to a fixed dummy pattern to avoid symmetry/noise.
constraint forall(p in 1..MaxPatterns) (
  (use[p] = 0) -> (forall(t in T)(pat[p,t] = 0) /\ waste[p] = RawLen - 0)
);

% -------------------------------
% Constraints: counting pattern usage (hint: count)
% -------------------------------
constraint forall(p in 1..MaxPatterns) (
  count(pat_of_pipe, p, use[p])
);

constraint forall(p in 1..MaxPatterns) (
  used[p] <-> (use[p] > 0)
);

constraint count(used, true, nUsed);
constraint nUsed <= MaxPatterns;

% -------------------------------
% Constraints: meet demands exactly
% -------------------------------
constraint forall(t in T) (
  produced[t] = sum(p in 1..MaxPatterns)(use[p] * pat[p,t])
);

constraint forall(t in T) ( produced[t] = demand[t] );

% -------------------------------
% Constraints: ranking by usage frequency
% -------------------------------
constraint all_different(rank);

% Ensure rank is consistent with usage: higher use => better (smaller) rank
constraint forall(p in 1..MaxPatterns, q in 1..MaxPatterns where p != q) (
  (use[p] > use[q]) -> (rank[p] < rank[q])
);

% Tie-breaking to reduce symmetry: if same use, order patterns by index
constraint forall(p in 1..MaxPatterns, q in 1..MaxPatterns where p < q) (
  (use[p] = use[q]) -> (rank[p] < rank[q])
);

% Link each pipe's cost index to rank of its chosen pattern
constraint forall(i in 1..N)(
  costIdx[i] = rank[pat_of_pipe[i]]
);

% -------------------------------
% Objective: minimize total cost
% totalCost10 = sum_i (10 + rank[pattern_of_pipe_i])
%             = 10*N + sum_i costIdx[i]
% -------------------------------
constraint totalCost10 = 10*N + sum(i in 1..N)(costIdx[i]);

solve minimize totalCost10;

% -------------------------------
% Output: show patterns used, their compositions and frequencies
% -------------------------------
output
[
  "Total pipes used = ", show(N), "\n",
  "Total cost = ", show(totalCost10 div 10), ".", show(totalCost10 mod 10), " (in raw-pipe units)\n\n",
  "Patterns (only those with use>0):\n"
]
++
[
  if fix(use[p]) > 0 then
    "Pattern " ++ show(p) ++
    " | use=" ++ show(use[p]) ++
    " | rank=" ++ show(rank[p]) ++
    " | pieces=[" ++
      show(pat[p,1]) ++ "," ++ show(pat[p,2]) ++ "," ++ show(pat[p,3]) ++ "," ++ show(pat[p,4]) ++
    "] for lengths [290,315,350,455]" ++
    " | waste=" ++ show(waste[p]) ++ "\n"
  else
    ""
  endif
  | p in 1..MaxPatterns
]
++
[
  "\nProduced = ", show([produced[t] | t in T]), "\n",
  "Demand   = ", show(demand), "\n"
];