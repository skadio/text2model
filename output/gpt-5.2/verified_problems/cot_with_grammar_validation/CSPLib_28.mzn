% Parameters
int: v;          % number of distinct objects (points)
int: k;          % number of objects per block
int: lambda;     % number of blocks in which any pair of objects appears together

% Derived parameters
int: b = (lambda * v * (v - 1)) div (k * (k - 1));  % number of blocks
int: r = (lambda * (v - 1)) div (k - 1);            % blocks per object

set of int: V = 1..v;
set of int: B = 1..b;

% Variables
array[B, V] of var 0..1: x;  % x[j,i]=1 iff object i is in block j

% Constraints
constraint k >= 1 /\ v >= 1;
constraint k <= v;

% Ensure divisibility for integer b and r
constraint (lambda * v * (v - 1)) mod (k * (k - 1)) = 0;
constraint (lambda * (v - 1)) mod (k - 1) = 0;

% Each block contains exactly k objects
constraint
  forall(j in B) (
    sum(i in V)(x[j,i]) = k
  );

% Each object appears in exactly r blocks
constraint
  forall(i in V) (
    sum(j in B)(x[j,i]) = r
  );

% Every pair of distinct objects appears together in exactly lambda blocks
constraint
  forall(i1 in V, i2 in V where i1 < i2) (
    sum(j in B)(x[j,i1] * x[j,i2]) = lambda
  );

% Symmetry breaking: lexicographically non-increasing blocks (treat rows as bit-vectors)
constraint
  forall(j in 1..b-1) (
    lex_lesseq([x[j+1,i] | i in V], [x[j,i] | i in V])
  );

% Objective
solve satisfy;