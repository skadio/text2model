% Parameters
int: v;                      % Number of distinct objects
int: k;                      % Objects per block
int: lambda;                 % Pairwise concurrence

% Derived design parameters
int: r = (lambda * (v - 1)) div (k - 1);
int: b = (v * r) div k;

% Index sets
set of int: OBJECTS = 1..v;
set of int: BLOCKS  = 1..b;

% Sanity-check constraints on derived parameters
constraint (lambda * (v - 1)) mod (k - 1) = 0 /\
          (v * r) mod k = 0;

% Variables
array[OBJECTS, BLOCKS] of var 0..1: x;     % Incidence matrix (1 iff object i in block j)

% Constraints
% Row sums: each object appears in exactly r blocks
constraint
  forall(i in OBJECTS)(
    sum(j in BLOCKS)(x[i,j]) = r
  );

% Column sums: each block contains exactly k distinct objects
constraint
  forall(j in BLOCKS)(
    sum(i in OBJECTS)(x[i,j]) = k
  );

% Pairwise concurrence: every pair of objects occurs together in exactly lambda blocks
constraint
  forall(i, j in OBJECTS where i < j)(
    sum(b_ in BLOCKS)(x[i,b_] * x[j,b_]) = lambda
  );

% Objective
solve satisfy;