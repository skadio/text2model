% Parameters
int: v;          % number of objects (points)
int: k;          % block size
int: lambda;     % pair replication
int: b = (lambda * v * (v - 1)) div (k * (k - 1));
int: r = (lambda * (v - 1)) div (k - 1);

set of int: V = 1..v;
set of int: B = 1..b;

% Variables
array[B, V] of var 0..1: x;

% Constraints
constraint k >= 1 /\ v >= 1 /\ lambda >= 0;
constraint k <= v;

% divisibility / feasibility checks (force inconsistency if not integer)
constraint (lambda * (v - 1)) mod (k - 1) = 0;
constraint (lambda * v * (v - 1)) mod (k * (k - 1)) = 0;

% each block has exactly k objects
constraint
  forall(bb in B)(
    sum(p in V)(x[bb, p]) = k
  );

% each object appears in exactly r blocks
constraint
  forall(p in V)(
    sum(bb in B)(x[bb, p]) = r
  );

% every pair of distinct objects appears together in exactly lambda blocks
constraint
  forall(p in V, q in V where p < q)(
    sum(bb in B)(x[bb, p] * x[bb, q]) = lambda
  );

% symmetry breaking: lex order on blocks
constraint
  forall(bb in 1..b-1)(
    lex_lesseq([x[bb, p] | p in V], [x[bb+1, p] | p in V])
  );

% Objective
solve satisfy;