% Parameters (with values embedded)
int: L = 1850;                 % raw pipe length (mm)
int: max_patterns = 4;         % at most 4 cutting patterns
int: max_pieces_per_pipe = 5;  % at most 5 pieces from one raw pipe
int: max_waste = 100;          % leftover per pattern <= 100 mm

int: K = 4;                    % number of demanded piece types
array[1..K] of int: len = [290, 315, 350, 455];
array[1..K] of int: dem = [15, 28, 21, 30];

% Extra costs (in units of "1 raw pipe cost") for ranks 1..4:
% most frequent pattern: 1/10, second: 2/10, third: 3/10, fourth: 4/10
array[1..max_patterns] of int: rankCost10 = [1,2,3,4];  % scaled by 10

% Big-M bounds
int: maxPipes = sum(dem); % safe upper bound (one demanded piece per pipe)

% Variables
% Pattern composition: a[p,k] = number of pieces of type k cut under pattern p
array[1..max_patterns, 1..K] of var 0..max_pieces_per_pipe: a;

% Number of raw pipes cut with pattern p
array[1..max_patterns] of var 0..maxPipes: x;

% Whether pattern p is used
array[1..max_patterns] of var bool: used;

% Waste (leftover length) for each pattern (meaningful only if used)
array[1..max_patterns] of var 0..L: waste;

% Frequencies sorted descending: f[1] >= f[2] >= f[3] >= f[4]
array[1..max_patterns] of var 0..maxPipes: f;

% Total cost scaled by 10 to keep linear/integer:
% 10 * (sum x)  +  (1*f1 + 2*f2 + 3*f3 + 4*f4)
var 0..(10*maxPipes + 4*maxPipes): totalCost10;

% Constraints
% Link "used" with x
constraint forall(p in 1..max_patterns)(
  x[p] <= maxPipes * bool2int(used[p]) /\
  x[p] >= bool2int(used[p])
);

% At most 4 patterns used (already have 4 slots, but enforce explicitly)
constraint sum(p in 1..max_patterns)(bool2int(used[p])) <= max_patterns;

% Pattern piece-count and feasibility (length and waste) with conditional activation
constraint forall(p in 1..max_patterns)(
  % if not used => no pieces defined and zero waste
  (not used[p]) -> (
    x[p] = 0 /\
    waste[p] = 0 /\
    forall(k in 1..K)(a[p,k] = 0)
  )
);

constraint forall(p in 1..max_patterns)(
  used[p] ->
  (
    % at most 5 pieces per pipe under this pattern
    sum(k in 1..K)(a[p,k]) >= 1 /\
    sum(k in 1..K)(a[p,k]) <= max_pieces_per_pipe /\
    % compute waste and enforce <= 100
    waste[p] = L - sum(k in 1..K)(a[p,k] * len[k]) /\
    waste[p] >= 0 /\
    waste[p] <= max_waste
  )
);

% Demand satisfaction: total pieces produced across patterns meets exact demand
constraint forall(k in 1..K)(
  sum(p in 1..max_patterns)(x[p] * a[p,k]) = dem[k]
);

% Sort pattern usages into nonincreasing frequencies f[1..4]
constraint forall(i in 1..max_patterns)(
  sum(p in 1..max_patterns)(bool2int(x[p] >= f[i])) >= i
);
constraint forall(i in 1..max_patterns)(
  sum(p in 1..max_patterns)(bool2int(x[p] > f[i])) <= i-1
);

% Nonincreasing order (redundant but helps)
constraint forall(i in 1..max_patterns-1)(f[i] >= f[i+1]);

% Objective (scaled by 10)
constraint totalCost10 = 10 * sum(p in 1..max_patterns)(x[p])
                       + sum(i in 1..max_patterns)(rankCost10[i] * f[i]);

solve minimize totalCost10;

output [
  "Total cost (in raw-pipe units) = ", show(totalCost10), "/10 = ",
  show(totalCost10 div 10), ".", show((totalCost10 mod 10)), "\n",
  "Total raw pipes used = ", show(sum(p in 1..max_patterns)(x[p])), "\n",
  "Frequencies sorted f = ", show(f), "\n\n",
  "Patterns (p: x, waste, pieces [290,315,350,455]):\n"
] ++
[
  if fix(used[p]) then
    "p" ++ show(p) ++ ": x=" ++ show(x[p]) ++
    ", waste=" ++ show(waste[p]) ++
    ", a=" ++ show([a[p,k] | k in 1..K]) ++ "\n"
  else
    ""
  endif
  | p in 1..max_patterns
];