% Parameters
int: raw_length = 1850;                % Length (mm) of each raw pipe
int: max_patterns = 4;                 % Maximum number of cutting patterns allowed
int: max_pieces_per_pipe = 5;          % At most 5 pieces cut from a single raw pipe (per pattern)
int: max_leftover = 100;               % Leftover (mm) per pattern must be <= 100

int: n_types = 4;                      % Number of demanded piece types
set of int: TYPES = 1..n_types;

array[TYPES] of int: piece_len = [290, 315, 350, 455];   % Required lengths (mm)
array[TYPES] of int: demand    = [15, 28, 21, 30];       % Required quantities per length

set of int: PATTERNS = 1..max_patterns;

int: total_demand = sum(t in TYPES)(demand[t]);          % Total number of required pieces

% Upper bound on number of raw pipes needed (safe bound): each pipe yields at least 1 piece
int: max_pipes = total_demand;

% Extra cost fractions depending on usage rank (1st most used: 1/10, 2nd: 2/10, ...)
% Cost modeled in "tenths of a raw pipe" to stay integral.
array[PATTERNS] of int: extra_cost_tenths_by_rank = [1, 2, 3, 4];


% Variables
array[PATTERNS, TYPES] of var 0..max_pieces_per_pipe: pieces_in_pattern;
  % pieces_in_pattern[p,t] = number of pieces of type t produced by pattern p on one raw pipe

array[PATTERNS] of var 0..max_pieces_per_pipe: pieces_per_pipe;
  % total pieces produced by pattern p on one raw pipe (<= 5)

array[PATTERNS] of var 0..raw_length: used_length;
  % total used length (mm) per raw pipe under pattern p

array[PATTERNS] of var 0..max_leftover: leftover;
  % leftover length (mm) per raw pipe under pattern p (<= 100)

array[PATTERNS] of var 0..max_pipes: pipes_used;
  % number of raw pipes cut with pattern p

array[PATTERNS] of var bool: pattern_used;
  % whether pattern p is selected/used at all

var 0..max_pipes: total_pipes;
  % total number of raw pipes used across all patterns

array[PATTERNS] of var 0..max_pipes: usage_count;
  % usage_count[p] = pipes_used[p]; kept explicitly for clarity/ranking

array[PATTERNS] of var 1..max_patterns: usage_rank;
  % usage_rank[p] is the rank of pattern p by usage frequency (1 = most used, ...)

array[PATTERNS] of var 0..4: extra_cost_tenths;
  % extra_cost_tenths[p] is the extra cost (in tenths of a raw pipe) assigned to pattern p
  % depending on its usage_rank (1->1, 2->2, 3->3, 4->4)

var 0..(14*max_pipes): total_cost_tenths;
  % total cost in tenths of a raw pipe:
  % 10 per raw pipe + extra cost depending on rank and usage


% Constraints

%--------------------------
% Pattern composition / feasibility
%--------------------------

% Compute used length per raw pipe for each pattern
constraint
  forall(p in PATTERNS)(
    used_length[p] = sum(t in TYPES)(pieces_in_pattern[p,t] * piece_len[t])
  );

% Total number of pieces produced per raw pipe for each pattern
constraint
  forall(p in PATTERNS)(
    pieces_per_pipe[p] = sum(t in TYPES)(pieces_in_pattern[p,t])
  );

% Enforce max pieces per raw pipe
constraint
  forall(p in PATTERNS)(
    pieces_per_pipe[p] <= max_pieces_per_pipe
  );

% Leftover definition and bounds; also enforce usable stock length
constraint
  forall(p in PATTERNS)(
    leftover[p] = raw_length - used_length[p] /\
    used_length[p] <= raw_length /\
    leftover[p] <= max_leftover
  );

%--------------------------
% Pattern usage linking
%--------------------------

% Link pattern_used with pipes_used (pattern is used iff at least one pipe uses it)
constraint
  forall(p in PATTERNS)(
    pattern_used[p] <-> (pipes_used[p] >= 1)
  );

% If a pattern is not used, it produces nothing (avoid "unused but defined" patterns)
constraint
  forall(p in PATTERNS, t in TYPES)(
    (not pattern_used[p]) -> (pieces_in_pattern[p,t] = 0)
  );

% Count used patterns must not exceed the allowed maximum (redundant here, but explicit)
constraint
  sum(p in PATTERNS)(bool2int(pattern_used[p])) <= max_patterns;

% Define usage_count as pipes_used (explicit equality for ranking model)
constraint
  forall(p in PATTERNS)(
    usage_count[p] = pipes_used[p]
  );

% Total pipes used
constraint
  total_pipes = sum(p in PATTERNS)(pipes_used[p]);

%--------------------------
% Demand satisfaction
%--------------------------

% Produce at least the demanded quantity for each type
constraint
  forall(t in TYPES)(
    sum(p in PATTERNS)(pipes_used[p] * pieces_in_pattern[p,t]) >= demand[t]
  );

%--------------------------
% Ranking of patterns by usage frequency
%--------------------------

% Ranks are a permutation of 1..max_patterns
constraint
  all_different([usage_rank[p] | p in PATTERNS]);

% Enforce ordering: if p has better rank than q, then usage_count[p] >= usage_count[q]
constraint
  forall(p in PATTERNS, q in PATTERNS where p != q)(
    (usage_rank[p] < usage_rank[q]) -> (usage_count[p] >= usage_count[q])
  );

%--------------------------
% Extra cost assignment by rank
%--------------------------

% extra_cost_tenths[p] determined by its rank (1->1, 2->2, 3->3, 4->4)
constraint
  forall(p in PATTERNS)(
    extra_cost_tenths[p] = extra_cost_tenths_by_rank[usage_rank[p]]
  );

% Total cost in tenths of a raw pipe:
% - Base cost: 10 per raw pipe
% - Extra cost: (extra_cost_tenths[p]) per pipe using pattern p
constraint
  total_cost_tenths =
    10 * total_pipes
    + sum(p in PATTERNS)(extra_cost_tenths[p] * pipes_used[p]);


% Objective
solve minimize total_cost_tenths;