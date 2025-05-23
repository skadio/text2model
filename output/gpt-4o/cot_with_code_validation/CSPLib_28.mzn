int: v;                 % Number of distinct objects
int: k;                 % Objects per block
int: lambda;            % Pairwise concurrence

% Derived parameters
int: b = (v*(v-1)*lambda) div (k*(k-1));   % Number of blocks
int: r = (lambda*(v-1)) div (k-1);         % Replications per object

% Feasibility checks (necessary conditions)
constraint (v*(v-1)*lambda) mod (k*(k-1)) = 0;
constraint (lambda*(v-1))    mod (k-1)   = 0;

% Sets
set of int: OBJ = 1..v;
set of int: BLK = 1..b;

% Variables
array[OBJ, BLK] of var 0..1: x;            % Incidence matrix

% 1. Each block contains exactly k objects
constraint
  forall(j in BLK)(
    sum(i in OBJ)(x[i,j]) = k
  );

% 2. Each object appears in exactly r blocks
constraint
  forall(i in OBJ)(
    sum(j in BLK)(x[i,j]) = r
  );

% 3. Every pair of objects occurs together in exactly lambda blocks
constraint
  forall(i1 in 1..v-1, i2 in i1+1..v)(
    sum(j in BLK)(x[i1,j] * x[i2,j]) = lambda
  );

solve satisfy;