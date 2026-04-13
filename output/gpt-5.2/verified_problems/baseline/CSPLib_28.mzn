int: v;
int: k;
int: lambda;

set of int: OBJ = 1..v;

% Derived BIBD parameters (must be integral for a feasible design)
int: r = (lambda * (v - 1)) div (k - 1);                 % blocks per object
int: b = (v * r) div k;                                   % number of blocks

constraint (lambda * (v - 1)) mod (k - 1) = 0;
constraint (v * r) mod k = 0;

set of int: BLK = 1..b;

array[BLK, 1..k] of var OBJ: block;

% Within each block, objects are distinct and ordered (symmetry breaking)
constraint
  forall(j in BLK) (
    all_different([block[j,t] | t in 1..k]) /\
    forall(t in 1..k-1)(block[j,t] < block[j,t+1])
  );

% Each object appears in exactly r blocks
constraint
  forall(o in OBJ)(
    sum(j in BLK, t in 1..k)(bool2int(block[j,t] = o)) = r
  );

% Every unordered pair of distinct objects appears together in exactly lambda blocks
constraint
  forall(a in OBJ, c in OBJ where a < c)(
    sum(j in BLK)(
      bool2int( exists(t in 1..k)(block[j,t] = a) /\ exists(t in 1..k)(block[j,t] = c) )
    ) = lambda
  );

% Additional symmetry breaking: lex order of blocks
include "globals.mzn";
constraint
  lex_chain([ [block[j,t] | t in 1..k] | j in BLK ]);

solve satisfy;

output [
  "v=", show(v), " k=", show(k), " lambda=", show(lambda), "\n",
  "r=", show(r), " b=", show(b), "\n",
  "blocks:\n"
] ++
[ show(j) ++ ": " ++ show([block[j,t] | t in 1..k]) ++ "\n" | j in BLK ];