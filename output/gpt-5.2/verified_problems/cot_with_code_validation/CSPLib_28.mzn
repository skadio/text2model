% Balanced Incomplete Block Design (BIBD)
% Parameters (must be provided in the .dzn)
int: v;        % number of distinct objects (points)
int: k;        % number of objects per block
int: lambda;   % number of blocks in which each pair of objects occurs together

% Derived parameters (assumes feasibility; see constraints below)
int: b = (lambda * v * (v - 1)) div (k * (k - 1));   % number of blocks
int: r = (lambda * (v - 1)) div (k - 1);             % blocks per object

set of int: V = 1..v;
set of int: B = 1..b;

% Decision variables
array[B, V] of var 0..1: x;  % x[block, object] = 1 iff object is in block

% Basic feasibility conditions
constraint k >= 1 /\ k <= v;
constraint lambda >= 0;
constraint (k >= 2) -> ((lambda * (v - 1)) mod (k - 1) = 0);
constraint (k >= 2) -> ((lambda * v * (v - 1)) mod (k * (k - 1)) = 0);

% Each block contains exactly k objects
constraint forall(bb in B) (
  sum(oo in V)(x[bb, oo]) = k
);

% Each object appears in exactly r blocks
constraint forall(oo in V) (
  sum(bb in B)(x[bb, oo]) = r
);

% Each pair of distinct objects appears together in exactly lambda blocks
constraint forall(o1 in V, o2 in V where o1 < o2) (
  sum(bb in B)(x[bb, o1] * x[bb, o2]) = lambda
);

% Symmetry breaking: lexicographically nondecreasing blocks
constraint forall(bb in 1..b-1) (
  lex_lesseq([x[bb, oo] | oo in V], [x[bb+1, oo] | oo in V])
);

solve satisfy;