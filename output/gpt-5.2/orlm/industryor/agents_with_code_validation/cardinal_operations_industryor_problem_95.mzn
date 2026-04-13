include "globals.mzn";

% Parameters
int: raw_length = 1850;                 % Length of one raw pipe (mm)
int: max_patterns = 4;                  % Maximum number of cutting patterns allowed
int: max_pieces_per_pipe = 5;           % At most 5 pieces can be produced from one raw pipe
int: max_leftover = 100;                % Leftover length per pattern may not exceed 100 mm

int: n_types = 4;                       % Number of demanded piece types
set of int: TYPES = 1..n_types;

array[TYPES] of int: piece_len = [290, 315, 350, 455];   % Required piece lengths (mm)
array[TYPES] of int: demand    = [15,  28,  21,  30 ];   % Required quantities

% Cost increment fractions for patterns ranked by usage frequency
set of int: RANKS = 1..max_patterns;
int: rank_cost_den = 10;

% A safe upper bound on the number of raw pipes needed (for variable bounds)
int: max_raw_pipes = sum(demand); % safe bound (each pipe produces at least 1 piece)

set of int: PATTERNS = 1..max_patterns;

% Variables
array[PATTERNS, TYPES] of var 0..max_pieces_per_pipe: pieces_in_pattern;
% pieces_in_pattern[p,t] = number of pieces of type t produced by pattern p (per raw pipe)

array[PATTERNS] of var 0..max_raw_pipes: pipes_used;
% pipes_used[p] = number of raw pipes cut using pattern p

array[PATTERNS] of var 0..raw_length: used_length;
array[PATTERNS] of var 0..raw_length: leftover;

array[PATTERNS] of var 0..max_pieces_per_pipe: pieces_per_pipe;

array[PATTERNS] of var bool: pattern_active;

array[TYPES] of var 0..sum(demand): produced;

array[PATTERNS] of var 0..max_raw_pipes: freq;

array[PATTERNS] of var 1..max_patterns: rank;

array[PATTERNS] of var 0..(max_raw_pipes + 1) * max_raw_pipes + max_patterns: rank_key;

var 0..max_raw_pipes * max_patterns: total_raw_pipes;

var int: total_cost_num;
% Objective expressed as numerator over denominator=10:
% total_cost = (10*total_raw_pipes + sum_p rank[p]*pipes_used[p]) / 10

% Constraints

% --- Link frequency and activity indicators ---
constraint forall(p in PATTERNS) ( freq[p] = pipes_used[p] );
constraint forall(p in PATTERNS) ( pattern_active[p] <-> (pipes_used[p] > 0) );

% --- Pattern composition: pieces per pipe, used length, leftover ---
constraint forall(p in PATTERNS) (
  pieces_per_pipe[p] = sum(t in TYPES)(pieces_in_pattern[p,t])
);
constraint forall(p in PATTERNS) ( pieces_per_pipe[p] <= max_pieces_per_pipe );

constraint forall(p in PATTERNS) (
  used_length[p] = sum(t in TYPES)(pieces_in_pattern[p,t] * piece_len[t])
);
constraint forall(p in PATTERNS) ( used_length[p] <= raw_length );
constraint forall(p in PATTERNS) ( leftover[p] = raw_length - used_length[p] );

% Leftover per pattern may not exceed max_leftover when the pattern is active
constraint forall(p in PATTERNS) (
  pattern_active[p] -> (leftover[p] <= max_leftover)
);

% If a pattern is inactive, force its definition to a canonical "zero" pattern
constraint forall(p in PATTERNS) (
  (not pattern_active[p]) -> (
    pipes_used[p] = 0 /\
    pieces_per_pipe[p] = 0 /\
    used_length[p] = 0 /\
    leftover[p] = raw_length /\
    forall(t in TYPES)(pieces_in_pattern[p,t] = 0)
  )
);

% --- Production totals and demand satisfaction ---
constraint forall(t in TYPES) (
  produced[t] = sum(p in PATTERNS)(pipes_used[p] * pieces_in_pattern[p,t])
);
constraint forall(t in TYPES) ( produced[t] >= demand[t] );

% --- Total raw pipes used ---
constraint total_raw_pipes = sum(p in PATTERNS)(pipes_used[p]);

% --- Ranking of patterns by usage frequency (1 = most used) ---
% Use a big-M ordering key: higher freq => smaller rank_key, and include rank to break ties.
int: M = max_raw_pipes + 1;

constraint forall(p in PATTERNS) (
  rank_key[p] = M * (max_raw_pipes - freq[p]) + rank[p]
);

% Enforce that ranks form a permutation of 1..max_patterns
constraint all_different(rank);

% If pattern i has smaller rank (more frequent), its key must be <= that of pattern j
constraint forall(i, j in PATTERNS where i < j) (
  (rank[i] < rank[j]) -> (rank_key[i] <= rank_key[j])
);

% Inactive patterns cannot get a better (smaller) rank than any active pattern
constraint forall(p, q in PATTERNS) (
  (pattern_active[p] /\ not pattern_active[q]) -> (rank[p] < rank[q])
);

% --- Objective numerator definition ---
constraint
  total_cost_num =
    rank_cost_den * total_raw_pipes
    + sum(p in PATTERNS)(rank[p] * pipes_used[p]);

% Objective
solve minimize total_cost_num;