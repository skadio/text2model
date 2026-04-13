include "globals.mzn";

% Parameters (given in .dzn)
int: v;          % number of objects (points)
int: k;          % block size
int: lambda;     % pair replication

set of int: P = 1..v;

% Derived BIBD parameters (must be integers)
int: r = (lambda * (v - 1)) div (k - 1);
int: b = (v * r) div k;

% Feasibility / integrality checks
constraint v > 0 /\ k > 0 /\ lambda >= 0;
constraint k <= v;
constraint k > 1; % needed for (k-1) in BIBD equations
constraint (lambda * (v - 1)) mod (k - 1) = 0;
constraint (v * r) mod k = 0;

% Variables
array[P, 1..b] of var 0..1: incidence; % incidence[p, blk] = 1 iff point p in block blk

% Constraints
% Each block has exactly k points
constraint forall(blk in 1..b) (
  sum(p in P)(incidence[p, blk]) = k
);

% Each point appears in exactly r blocks
constraint forall(p in P) (
  sum(blk in 1..b)(incidence[p, blk]) = r
);

% Each pair of distinct points appears together in exactly lambda blocks
constraint forall(p1 in P, p2 in P where p1 < p2) (
  sum(blk in 1..b)(incidence[p1, blk] * incidence[p2, blk]) = lambda
);

% Symmetry breaking: non-increasing lex order of columns (blocks)
constraint forall(blk in 1..b-1) (
  lex_lesseq([incidence[p, blk+1] | p in P], [incidence[p, blk] | p in P])
);

% Symmetry breaking: non-increasing lex order of rows (points)
constraint forall(p in 1..v-1) (
  lex_lesseq([incidence[p+1, blk] | blk in 1..b], [incidence[p, blk] | blk in 1..b])
);

solve satisfy;