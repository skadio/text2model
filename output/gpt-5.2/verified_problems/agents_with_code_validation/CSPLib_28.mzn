include "globals.mzn";

% Parameters
int: v;                 % Number of distinct objects (points)
int: k;                 % Number of objects in each block (block size)
int: lambda;            % Number of blocks in which each pair of objects co-occurs

% Helpful index sets
set of int: OBJ = 1..v;

% Derived constants from BIBD identities
int: b = (lambda * v * (v - 1)) div (k * (k - 1));    % Number of blocks
int: r = (lambda * (v - 1)) div (k - 1);              % Replication number

set of int: BLK = 1..b;

% Variables
array[OBJ, BLK] of var 0..1: inc;        % inc[i,j] = 1 iff object i is in block j
array[BLK, 1..k] of var OBJ: block_obj;  % The k objects selected for each block

% Constraints

% Each block contains exactly k objects
constraint
  forall(j in BLK)(
    sum(i in OBJ)(inc[i,j]) = k
  );

% Each object appears in exactly r blocks
constraint
  forall(i in OBJ)(
    sum(j in BLK)(inc[i,j]) = r
  );

% Each pair of objects co-occurs in exactly lambda blocks
constraint
  forall(i1 in OBJ, i2 in OBJ where i1 < i2)(
    sum(j in BLK)(inc[i1,j] * inc[i2,j]) = lambda
  );

% Channeling between block_obj and incidence matrix

% Each listed object in a block is present in inc
constraint
  forall(j in BLK, p in 1..k)(
    inc[block_obj[j,p], j] = 1
  );

% No repeats inside a block
constraint
  forall(j in BLK)(
    all_different([ block_obj[j,p] | p in 1..k ])
  );

% Every object marked present in inc must appear in block_obj
constraint
  forall(j in BLK, i in OBJ)(
    inc[i,j] = 1 <-> exists(p in 1..k)(block_obj[j,p] = i)
  );

solve satisfy;